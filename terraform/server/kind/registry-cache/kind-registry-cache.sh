#!/usr/bin/env bash
#
# kind-registry-cache.sh - transparent pull-through image cache for kind
#
# Starts the pull-through caches defined in docker-compose.yml and points every
# kind node's containerd at them. Images keep their normal names in Helm charts
# and manifests:
#
#     nginx                       -> docker.io cache
#     ghcr.io/owner/app:1.2.3     -> ghcr.io cache
#     quay.io/org/tool:latest     -> quay.io cache
#     registry.istio.io/release/pilot:1.30.3 -> registry.istio.io cache
#
# Nothing has to be renamed or prefixed. The first pull of an image goes
# upstream; afterwards it is served locally.
#
# Usage:
#   ./kind-registry-cache.sh up            # start caches + patch all kind nodes
#   ./kind-registry-cache.sh status        # show caches and node config
#   ./kind-registry-cache.sh logs [name]   # follow logs (dockerhub|ghcr|quay|istio)
#   ./kind-registry-cache.sh down          # stop/remove caches (keep data)
#   ./kind-registry-cache.sh purge         # down + delete cached data
#
# Re-run `up` after (re)creating the kind cluster so the new nodes get the
# mirror config. The caches live in docker volumes and survive recreation.
#
# Configuration (environment variables, all optional):
#   KIND_CLUSTER_NAME               kind cluster name (default: kind)
#   KIND_CACHE_REGISTRIES           registries to cache, space or comma
#                                   separated (default: dockerhub ghcr quay istio)
#   KIND_CACHE_RESTART_CONTAINERD   "1" to restart containerd after writing
#                                   the config (default: 0)
#
# Cache image and host ports are fixed in docker-compose.yml:
#   docker.io 5001, ghcr.io 5002, quay.io 5003, registry.istio.io 5004
#
# All upstreams are pulled anonymously; no credentials are configured.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.yml"

KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-kind}"
KIND_CACHE_REGISTRIES="${KIND_CACHE_REGISTRIES:-dockerhub ghcr quay istio}"
KIND_CACHE_RESTART_CONTAINERD="${KIND_CACHE_RESTART_CONTAINERD:-0}"

KNOWN_REGISTRIES="dockerhub ghcr quay istio"

# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

die() { echo "error: $*" >&2; exit 1; }
info() { echo "==> $*"; }

require_docker() {
  command -v docker >/dev/null 2>&1 || die "docker is not installed or not on PATH"
  docker info >/dev/null 2>&1 || die "cannot talk to the docker daemon - is Docker Desktop running?"
  [ -f "${COMPOSE_FILE}" ] || die "missing ${COMPOSE_FILE}"
}

compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose -f "${COMPOSE_FILE}" "$@"
  elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose -f "${COMPOSE_FILE}" "$@"
  else
    die "docker compose (v2) or docker-compose is required"
  fi
}

# accept both profile names and registry hosts
to_profile() {
  case "$1" in
    dockerhub|docker.io) echo dockerhub ;;
    ghcr|ghcr.io)        echo ghcr ;;
    quay|quay.io)        echo quay ;;
    istio|registry.istio.io) echo istio ;;
    *) die "unknown registry '$1' (known: ${KNOWN_REGISTRIES})" ;;
  esac
}

reg_host() {
  case "$1" in
    dockerhub) echo docker.io ;;
    ghcr)      echo ghcr.io ;;
    quay)      echo quay.io ;;
    istio)     echo registry.istio.io ;;
  esac
}

# upstream registry the cache falls back to (containerd `server`)
reg_server() {
  case "$1" in
    dockerhub) echo https://registry-1.docker.io ;;
    ghcr)      echo https://ghcr.io ;;
    quay)      echo https://quay.io ;;
    istio)     echo https://registry.istio.io ;;
  esac
}

reg_container() { echo "kind-cache-$1"; }

reg_port() {
  case "$1" in
    dockerhub) echo 5001 ;;
    ghcr)      echo 5002 ;;
    quay)      echo 5003 ;;
    istio)     echo 5004 ;;
  esac
}

# enabled profile names, deduplicated, in the order given
enabled_registries() {
  local out="" tok prof
  for tok in $(echo "${KIND_CACHE_REGISTRIES}" | tr ',' ' '); do
    prof="$(to_profile "${tok}")"
    case " ${out} " in *" ${prof} "*) continue ;; esac
    out="${out:+${out} }${prof}"
  done
  [ -n "${out}" ] || die "KIND_CACHE_REGISTRIES is empty"
  echo "${out}"
}

disabled_registries() {
  local enabled r out=""
  enabled=" $(enabled_registries) "
  for r in ${KNOWN_REGISTRIES}; do
    case "${enabled}" in *" ${r} "*) ;; *) out="${out:+${out} }${r}" ;; esac
  done
  echo "${out}"
}

kind_nodes() {
  docker ps -a --filter "label=io.x-k8s.kind.cluster=${KIND_CLUSTER_NAME}" --format '{{.Names}}'
}

kind_nodes_running() {
  docker ps --filter "label=io.x-k8s.kind.cluster=${KIND_CLUSTER_NAME}" --format '{{.Names}}'
}

container_running() {
  [ "$(docker inspect -f '{{.State.Running}}' "$1" 2>/dev/null || true)" = "true" ]
}

container_exists() {
  docker inspect "$1" >/dev/null 2>&1
}

ensure_network() {
  if [ "$(docker network ls --filter 'name=^kind$' --format '{{.Name}}')" = "kind" ]; then
    return
  fi
  info "creating docker network 'kind'"
  docker network create kind >/dev/null
}

ensure_volumes() {
  # compose declares the cache volumes as external, so they must exist first
  local r vol
  for r in $(enabled_registries); do
    vol="kind-cache-${r}-data"
    if ! docker volume inspect "${vol}" >/dev/null 2>&1; then
      info "creating cache volume ${vol}"
      docker volume create "${vol}" >/dev/null
    fi
  done
}

write_node_mirror() {
  # write /etc/containerd/certs.d/<host>/hosts.toml inside one node
  local node="$1" host="$2" cname="$3" server="$4"
  local dir="/etc/containerd/certs.d/${host}"
  docker exec "${node}" mkdir -p "${dir}"
  cat <<EOF | docker exec -i "${node}" cp /dev/stdin "${dir}/hosts.toml"
# Managed by kind-registry-cache.sh - edits will be overwritten.
# The cache is tried first; the default registry is the fallback.
server = "${server}"

[host."http://${cname}:5000"]
  capabilities = ["pull", "resolve"]
EOF
}

remove_node_mirror() {
  # remove a mirror config this script wrote earlier for a now-disabled cache
  local node="$1" host="$2" file="/etc/containerd/certs.d/$2/hosts.toml"
  if docker exec "${node}" grep -qs "Managed by kind-registry-cache.sh" "${file}" 2>/dev/null; then
    info "removing stale mirror config for ${host} on ${node}"
    docker exec "${node}" rm -f "${file}"
  fi
}

wait_for_caches() {
  local r port tries
  for r in $(enabled_registries); do
    port="$(reg_port "${r}")"
    tries=0
    until curl -s -o /dev/null "http://127.0.0.1:${port}/v2/" 2>/dev/null; do
      tries=$((tries + 1))
      if [ "${tries}" -ge 30 ]; then
        die "cache for $(reg_host "${r}") did not become ready on port ${port}"
      fi
      sleep 1
    done
  done
}

check_node_config() {
  local node="$1" r has
  has=""
  for r in $(enabled_registries); do
    if docker exec "${node}" test -f "/etc/containerd/certs.d/$(reg_host "${r}")/hosts.toml" 2>/dev/null; then
      has="${has} $(reg_host "${r}")"
    fi
  done
  printf '  %-30s mirror-config:%s\n' "${node}" "${has:- none}"
}

# ---------------------------------------------------------------------------
# commands
# ---------------------------------------------------------------------------

remove_disabled_caches() {
  local r cname
  for r in $(disabled_registries); do
    cname="$(reg_container "${r}")"
    if container_exists "${cname}"; then
      info "stopping disabled cache ${cname}"
      docker rm -f "${cname}" >/dev/null
    fi
  done
}

patch_nodes() {
  local nodes r host
  nodes="$(kind_nodes_running)"
  if [ -z "${nodes}" ]; then
    echo
    echo "note: no running nodes found for kind cluster '${KIND_CLUSTER_NAME}'." >&2
    echo "      the caches are up - create the cluster and run '$0 up' again." >&2
    return
  fi

  for node in ${nodes}; do
    info "patching containerd mirror config on node ${node}"
    for r in $(enabled_registries); do
      write_node_mirror "${node}" "$(reg_host "${r}")" "$(reg_container "${r}")" "$(reg_server "${r}")"
    done
    for r in $(disabled_registries); do
      remove_node_mirror "${node}" "$(reg_host "${r}")"
    done
    if [ "${KIND_CACHE_RESTART_CONTAINERD}" = "1" ]; then
      info "restarting containerd on ${node}"
      docker exec "${node}" systemctl restart containerd || true
    fi
  done
}

print_summary() {
  local r disabled
  echo
  info "pull-through caches are ready"
  for r in $(enabled_registries); do
    printf '    %-22s -> %-22s (http://127.0.0.1:%s)\n' \
      "$(reg_host "${r}")" "$(reg_container "${r}")" "$(reg_port "${r}")"
  done

  disabled="$(disabled_registries)"
  if [ -n "${disabled}" ]; then
    echo
    printf '    not cached (pulled directly):'
    for r in ${disabled}; do printf ' %s' "$(reg_host "${r}")"; done
    echo
  fi

  echo
  echo "Images in Helm charts keep their original names. Re-run '$0 up'"
  echo "after the kind cluster is recreated so new nodes get the config."
}

up() {
  require_docker
  ensure_network
  ensure_volumes

  local enabled r args=()
  enabled="$(enabled_registries)"
  for r in ${enabled}; do args+=(--profile "${r}"); done

  info "starting caches: ${enabled}"
  compose ${args[@]+"${args[@]}"} up -d ${enabled}
  wait_for_caches
  remove_disabled_caches

  patch_nodes
  print_summary
}

status() {
  local r host cname port state reach code
  printf '%-22s %-22s %-8s %-10s %s\n' "UPSTREAM" "CONTAINER" "PORT" "STATE" "REACHABLE"
  for r in $(enabled_registries); do
    host="$(reg_host "${r}")"
    cname="$(reg_container "${r}")"
    port="$(reg_port "${r}")"
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
    printf '%-22s %-22s %-8s %-10s %s\n' "${host}" "${cname}" "${port}" "${state}" "${reach}"
  done

  local disabled
  disabled="$(disabled_registries)"
  if [ -n "${disabled}" ]; then
    echo "disabled: ${disabled}"
  fi

  echo
  echo "kind nodes:"
  local nodes
  nodes="$(kind_nodes)"
  if [ -z "${nodes}" ]; then
    echo "  (none for cluster '${KIND_CLUSTER_NAME}')"
  else
    for n in ${nodes}; do
      check_node_config "${n}"
    done
  fi
}

logs() {
  local r
  r="$(to_profile "${1:-dockerhub}")"
  container_exists "$(reg_container "${r}")" || die "no cache container for '${r}' (try: $0 up)"
  docker logs -f --tail 100 "$(reg_container "${r}")"
}

down() {
  require_docker
  compose --profile "*" down
  info "cache data volumes kept (use '$0 purge' to delete them)"
}

purge() {
  require_docker
  compose --profile "*" down -v

  # Also remove volumes left behind by the pre-Compose version of this script.
  local r vol
  for r in ${KNOWN_REGISTRIES}; do
    vol="kind-cache-${r}-data"
    if docker volume inspect "${vol}" >/dev/null 2>&1; then
      info "deleting volume ${vol}"
      docker volume rm "${vol}" >/dev/null || true
    fi
  done
  info "cache data volumes deleted"
}

usage() {
  cat <<'EOF'
kind-registry-cache.sh - transparent pull-through image cache for kind

Usage:
  kind-registry-cache.sh up            start caches and patch all kind nodes
  kind-registry-cache.sh status        show caches and node config
  kind-registry-cache.sh logs [name]   follow logs (dockerhub|ghcr|quay|istio)
  kind-registry-cache.sh down          stop/remove caches (keep cached data)
  kind-registry-cache.sh purge         down plus delete cached data

Images in Helm charts keep their original names. Re-run 'up' after the kind
cluster is recreated so new nodes get the containerd mirror config.

Common environment variables:
  KIND_CLUSTER_NAME              kind cluster name (default: kind)
  KIND_CACHE_REGISTRIES          registries to cache (default: dockerhub ghcr quay istio)

Fixed host ports: docker.io 5001, ghcr.io 5002, quay.io 5003, registry.istio.io 5004.
Image and ports are defined in docker-compose.yml.

All upstreams are pulled anonymously; no credentials are needed.

Examples:
  KIND_CACHE_REGISTRIES="dockerhub ghcr istio" ./kind-registry-cache.sh up
  KIND_CACHE_REGISTRIES="docker.io,ghcr.io" ./kind-registry-cache.sh up
EOF
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

case "${1:-}" in
  up)     up ;;
  status) require_docker; status ;;
  logs)   require_docker; logs "${2:-dockerhub}" ;;
  down)   down ;;
  purge)  purge ;;
  ""|-h|--help|help) usage ;;
  *) echo "unknown command: $1" >&2; echo; usage; exit 1 ;;
esac
