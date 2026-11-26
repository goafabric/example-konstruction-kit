#!/usr/bin/env bash
#
# kind-registry-cache.sh
#
# Transparent pull-through image cache for kind on macOS.
#
# Starts one pull-through cache registry per upstream (Docker Hub, GHCR, Quay)
# and points every kind node's containerd at the matching cache using a
# certs.d/hosts.toml registry mirror. Because the mirror is keyed on the
# upstream *host* (docker.io, ghcr.io, quay.io), images keep their normal
# names in Helm charts and manifests:
#
#     nginx                       -> served from cache
#     docker.io/library/nginx     -> served from cache
#     ghcr.io/owner/app:1.2.3     -> served from cache
#     quay.io/org/tool:latest     -> served from cache
#
# Nothing has to be renamed, re-tagged or prefixed, and no chart changes.
# The first pull of an image goes upstream; afterwards it is served locally.
#
# Usage:
#   ./kind-registry-cache.sh up            # start caches + patch all kind nodes
#   ./kind-registry-cache.sh status        # show cache containers + reachability
#   ./kind-registry-cache.sh logs [host]   # follow logs (docker.io|ghcr.io|quay.io)
#   ./kind-registry-cache.sh down          # stop/remove caches (keep cached data)
#   ./kind-registry-cache.sh purge         # down + delete cached data
#
# Re-run `up` after (re)creating the kind cluster so the mirror config is
# re-applied to the new nodes. The caches and their data live in docker
# volumes and survive cluster recreation.
#
# Configuration (environment variables, all optional):
#   KIND_CLUSTER_NAME                 kind cluster name (default: kind)
#   KIND_CACHE_REGISTRY_IMAGE         cache image (default: registry:3)
#   KIND_CACHE_DOCKERHUB_PORT         host port for Docker Hub cache (default: 5001)
#   KIND_CACHE_GHCR_PORT              host port for GHCR cache       (default: 5002)
#   KIND_CACHE_QUAY_PORT              host port for Quay cache       (default: 5003)
#   KIND_CACHE_RESTART_CONTAINERD     "1" to restart containerd on nodes
#                                     after writing config (default: 0)
#   DOCKERHUB_USERNAME / DOCKERHUB_PASSWORD   credentials to avoid rate limits
#   GHCR_USERNAME      / GHCR_PASSWORD        credentials for private GHCR pulls
#   QUAY_USERNAME      / QUAY_PASSWORD        credentials for private Quay pulls
#
set -euo pipefail

KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-kind}"
KIND_CACHE_REGISTRY_IMAGE="${KIND_CACHE_REGISTRY_IMAGE:-registry:3}"
KIND_CACHE_RESTART_CONTAINERD="${KIND_CACHE_RESTART_CONTAINERD:-0}"

# upstream hosts we cache for; "docker.io" is containerd's name for Docker Hub
UPSTREAMS=(docker.io ghcr.io quay.io)

# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

die() { echo "error: $*" >&2; exit 1; }
info() { echo "==> $*"; }

require_docker() {
  command -v docker >/dev/null 2>&1 || die "docker is not installed or not on PATH"
  docker info >/dev/null 2>&1 || die "cannot talk to the docker daemon - is Docker Desktop running?"
}

# upstream host -> upstream registry base URL (containerd `server` fallback)
host_server() {
  case "$1" in
    docker.io) echo "https://registry-1.docker.io" ;;
    ghcr.io)   echo "https://ghcr.io" ;;
    quay.io)   echo "https://quay.io" ;;
    *)         die "unknown upstream host: $1" ;;
  esac
}

# upstream host -> cache container name
host_container() {
  case "$1" in
    docker.io) echo "kind-cache-dockerhub" ;;
    ghcr.io)   echo "kind-cache-ghcr" ;;
    quay.io)   echo "kind-cache-quay" ;;
    *)         die "unknown upstream host: $1" ;;
  esac
}

# upstream host -> host port (for optional host-side debugging)
host_port() {
  case "$1" in
    docker.io) echo "${KIND_CACHE_DOCKERHUB_PORT:-5001}" ;;
    ghcr.io)   echo "${KIND_CACHE_GHCR_PORT:-5002}" ;;
    quay.io)   echo "${KIND_CACHE_QUAY_PORT:-5003}" ;;
    *)         die "unknown upstream host: $1" ;;
  esac
}

# upstream host -> configured credentials ("user<TAB>password", empty if none)
host_credentials() {
  case "$1" in
    docker.io) printf '%s\t%s' "${DOCKERHUB_USERNAME:-}" "${DOCKERHUB_PASSWORD:-}" ;;
    ghcr.io)   printf '%s\t%s' "${GHCR_USERNAME:-}" "${GHCR_PASSWORD:-}" ;;
    quay.io)   printf '%s\t%s' "${QUAY_USERNAME:-}" "${QUAY_PASSWORD:-}" ;;
  esac
}

# every node container of the target cluster (needs no kind binary, just docker)
kind_nodes() {
  docker ps -a \
    --filter "label=io.x-k8s.kind.cluster=${KIND_CLUSTER_NAME}" \
    --format '{{.Names}}'
}

container_running() {
  [ "$(docker inspect -f '{{.State.Running}}' "$1" 2>/dev/null || true)" = "true" ]
}

container_exists() {
  docker inspect "$1" >/dev/null 2>&1
}

ensure_network() {
  if [ "$(docker network ls --filter "name=^kind$" --format '{{.Name}}')" = "kind" ]; then
    return
  fi
  info "creating docker network 'kind' (will be reused by the kind cluster)"
  docker network create kind >/dev/null
}

# ---------------------------------------------------------------------------
# up
# ---------------------------------------------------------------------------

upstream_port_is_used_by_other() {
  # port $1 must not be taken by a container other than $2
  local port="$1" self="$2" match
  match="$(docker ps --format '{{.Names}} {{.Ports}}' \
    | grep -E "${port}->" | awk '{print $1}' | grep -v "^${self}$" || true)"
  [ -n "${match}" ]
}

start_cache() {
  local host="$1"
  local cname remote port user pass vol

  cname="$(host_container "${host}")"
  remote="$(host_server "${host}")"
  port="$(host_port "${host}")"
  vol="${cname}-data"

  IFS=$'\t' read -r user pass <<<"$(host_credentials "${host}")"

  if container_running "${cname}"; then
    info "cache for ${host} already running (${cname}), ensuring network attachment"
    if [ "$(docker inspect -f "{{json .NetworkSettings.Networks.kind}}" "${cname}" 2>/dev/null || echo null)" = "null" ]; then
      docker network connect kind "${cname}"
    fi
    return
  fi

  if container_exists "${cname}"; then
    info "removing stale container ${cname}"
    docker rm -f "${cname}" >/dev/null
  fi

  if upstream_port_is_used_by_other "${port}" "${cname}"; then
    die "host port ${port} for the ${host} cache is already in use; set a different KIND_CACHE_*_PORT"
  fi

  local -a env_args=()
  if [ -n "${user}" ]; then
    env_args+=( -e "REGISTRY_PROXY_USERNAME=${user}" -e "REGISTRY_PROXY_PASSWORD=${pass}" )
  fi

  info "starting pull-through cache for ${host} -> ${remote} (container ${cname}, host port ${port})"
  docker run -d \
    --name "${cname}" \
    --restart=always \
    --label created-by=kind-registry-cache \
    --label "io.kind-registry-cache.host=${host}" \
    --network kind \
    -p "127.0.0.1:${port}:5000" \
    -e "REGISTRY_PROXY_REMOTEURL=${remote}" \
    ${env_args[@]+"${env_args[@]}"} \
    -v "${vol}:/var/lib/registry" \
    "${KIND_CACHE_REGISTRY_IMAGE}" >/dev/null
}

write_node_mirror() {
  # write /etc/containerd/certs.d/<host>/hosts.toml inside one node
  local node="$1" host="$2" cname="$3" server="$4"
  local dir="/etc/containerd/certs.d/${host}"
  docker exec "${node}" mkdir -p "${dir}"
  cat <<EOF | docker exec -i "${node}" cp /dev/stdin "${dir}/hosts.toml"
# Managed by kind-registry-cache.sh - edits will be overwritten.
# The default registry is listed last, so containerd tries the cache first
# and falls back to upstream if a pull through the cache fails.
server = "${server}"

[host."http://${cname}:5000"]
  capabilities = ["pull", "resolve"]
EOF
}

patch_nodes() {
  local nodes
  nodes="$(kind_nodes)"
  if [ -z "${nodes}" ]; then
    echo
    echo "note: no nodes found for kind cluster '${KIND_CLUSTER_NAME}'." >&2
    echo "      the caches are up - create the cluster and run '$0 up' again." >&2
    return
  fi

  local node host cname server
  for node in ${nodes}; do
    info "patching containerd mirror config on node ${node}"
    for host in "${UPSTREAMS[@]}"; do
      cname="$(host_container "${host}")"
      server="$(host_server "${host}")"
      write_node_mirror "${node}" "${host}" "${cname}" "${server}"
    done
    if [ "${KIND_CACHE_RESTART_CONTAINERD}" = "1" ]; then
      info "restarting containerd on ${node}"
      docker exec "${node}" systemctl restart containerd || true
    fi
  done
}

print_summary() {
  local host cname port
  echo
  info "pull-through caches are ready"
  for host in "${UPSTREAMS[@]}"; do
    cname="$(host_container "${host}")"
    port="$(host_port "${host}")"
    echo "    ${host}  ->  ${cname}  (http://127.0.0.1:${port})"
  done
  echo
  echo "Images in Helm charts keep their original names. Re-run '$0 up'"
  echo "after the kind cluster is recreated so new nodes get the config."
}

# ---------------------------------------------------------------------------
# status / logs / down / purge
# ---------------------------------------------------------------------------

status() {
  local host cname port state reach code
  printf '%-12s %-22s %-8s %-10s %s\n' "UPSTREAM" "CONTAINER" "PORT" "STATE" "REACHABLE"
  for host in "${UPSTREAMS[@]}"; do
    cname="$(host_container "${host}")"
    port="$(host_port "${host}")"
    if container_running "${cname}"; then
      state="running"
      code="$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:${port}/v2/" 2>/dev/null || echo 000)"
      if [ "${code}" = "200" ] || [ "${code}" = "401" ]; then
        reach="yes"
      else
        reach="no"
      fi
    else
      state="stopped"
      reach="-"
    fi
    printf '%-12s %-22s %-8s %-10s %s\n' "${host}" "${cname}" "${port}" "${state}" "${reach}"
  done
  echo
  echo "kind nodes:"
  local nodes
  nodes="$(kind_nodes)"
  if [ -z "${nodes}" ]; then
    echo "  (none for cluster '${KIND_CLUSTER_NAME}')"
  else
    for n in ${nodes}; do
      local has=no
      if docker exec "${n}" test -f /etc/containerd/certs.d/docker.io/hosts.toml 2>/dev/null; then
        has=yes
      fi
      printf '  %-30s mirror-config=%s\n' "${n}" "${has}"
    done
  fi
}

logs() {
  local host="${1:-docker.io}"
  local cname
  cname="$(host_container "${host}")"
  container_exists "${cname}" || die "no cache container for '${host}' (try: $0 up)"
  docker logs -f --tail 100 "${cname}"
}

down() {
  require_docker
  local host cname
  for host in "${UPSTREAMS[@]}"; do
    cname="$(host_container "${host}")"
    if container_exists "${cname}"; then
      info "removing ${cname}"
      docker rm -f "${cname}" >/dev/null
    fi
  done
  info "cache data volumes kept (use '$0 purge' to delete them)"
}

purge() {
  down
  local host cname
  for host in "${UPSTREAMS[@]}"; do
    cname="$(host_container "${host}")"
    if docker volume inspect "${cname}-data" >/dev/null 2>&1; then
      info "deleting volume ${cname}-data"
      docker volume rm "${cname}-data" >/dev/null
    fi
  done
}

usage() {
  cat <<'EOF'
kind-registry-cache.sh - transparent pull-through image cache for kind

Usage:
  kind-registry-cache.sh up            start caches and patch all kind nodes
  kind-registry-cache.sh status        show cache containers and reachability
  kind-registry-cache.sh logs [host]   follow logs (docker.io|ghcr.io|quay.io)
  kind-registry-cache.sh down          stop/remove caches (keep cached data)
  kind-registry-cache.sh purge         down plus delete cached data

Images in Helm charts keep their original names. Re-run 'up' after the kind
cluster is recreated so the new nodes get the containerd mirror config.

Common environment variables:
  KIND_CLUSTER_NAME              kind cluster name (default: kind)
  KIND_CACHE_DOCKERHUB_PORT      host port for Docker Hub cache (default: 5001)
  KIND_CACHE_GHCR_PORT           host port for GHCR cache       (default: 5002)
  KIND_CACHE_QUAY_PORT           host port for Quay cache       (default: 5003)
  DOCKERHUB_USERNAME/PASSWORD    Docker Hub credentials (avoids rate limits)
  GHCR_USERNAME/PASSWORD         GitHub Container Registry credentials
  QUAY_USERNAME/PASSWORD         Quay credentials
EOF
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

cmd="${1:-}"
case "${cmd}" in
  up)
    require_docker
    ensure_network
    for host in "${UPSTREAMS[@]}"; do
      start_cache "${host}"
    done
    patch_nodes
    print_summary
    ;;
  status) require_docker; status ;;
  logs)   require_docker; logs "${2:-docker.io}" ;;
  down)   down ;;
  purge)  purge ;;
  ""|-h|--help|help) usage ;;
  *) echo "unknown command: ${cmd}" >&2; echo; usage; exit 1 ;;
esac
