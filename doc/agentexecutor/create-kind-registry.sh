#!/usr/bin/env bash

# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit -o nounset -o pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-kind}"
KUBECTL_CONTEXT="kind-${KIND_CLUSTER_NAME}"
reg_name="kind-registry"
reg_port="${KIND_REGISTRY_PORT:-5001}"

if [[ $# -gt 0 ]]; then
  case "$1" in
    -h|--help)
      echo "Usage: $0"
      echo "Creates the local docker registry '${reg_name}' on port ${reg_port} and attaches it to"
      echo "the kind cluster '${KIND_CLUSTER_NAME}', and patches the cluster's nodes in place to"
      echo "enable the feature gates cmd/podcertcontroller needs, if they aren't already on."
      echo "Safe to run against a cluster that already exists: every step is idempotent and"
      echo "nothing is deleted or recreated."
      echo
      echo "Configured through the environment:"
      echo "  KIND_CLUSTER_NAME   Name of the cluster to attach the registry to (default: kind)."
      echo "  KIND_REGISTRY_PORT  Host port the registry is published on (default: 5001)."
      exit 0
      ;;
  esac
fi

# 1. Create registry container unless it already exists
echo "Setting up local docker registry '${reg_name}' on port ${reg_port}..."
if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" == "true" ]; then
  if ! docker port "${reg_name}" | grep -q "${reg_port}"; then
    echo "Registry exists but is not mapped to port ${reg_port}. Recreating..."
    docker rm -f "${reg_name}"
  fi
fi

if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" != "true" ]; then
  docker run \
    -d --restart=always \
    --label created-by=agent-substrate \
    -p "127.0.0.1:${reg_port}:5000" \
    -p "[::1]:${reg_port}:5000" \
    --network bridge --name "${reg_name}" \
    registry:3
fi

# 2. Ensure the feature gates cmd/podcertcontroller needs are enabled.
#
# cmd/podcertcontroller depends on ClusterTrustBundle & PodCertificateRequest.
# They are not enabled by default as of Kubernetes v1.36
# https://github.com/kubernetes/kubernetes/blob/master/test/compatibility_lifecycle/reference/versioned_feature_list.yaml
#
# kind only bakes featureGates/runtimeConfig into a node's static manifests at
# kubeadm-init time (see create-kind-cluster.sh), so a node created before
# these gates were added, or one kind stood up with a plain config, never gets
# them. There's no "kind reconfigure" for a live node, so patch the static
# kube-apiserver manifest and kubelet's own config in place and restart
# kubelet to pick both up. Skipped per node once already patched, so this is
# safe to run repeatedly against a cluster you don't want kind to recreate.
echo "Ensuring podcertcontroller feature gates are enabled on kind nodes..."
FEATURE_GATES="ClusterTrustBundle=true,ClusterTrustBundleProjection=true,PodCertificateRequest=true"
for node in $("${ROOT}"/hack/kind.sh get nodes --name "${KIND_CLUSTER_NAME}"); do
  needs_kubelet_restart=false

  # kubelet's own gate: needed on every node that might run a pod projecting
  # a ClusterTrustBundle volume, not just control-plane nodes.
  if ! docker exec "${node}" grep -q "PodCertificateRequest" /var/lib/kubelet/config.yaml 2>/dev/null; then
    echo "Patching kubelet config on node '${node}'..."
    docker exec "${node}" sed -i \
      '/^kind: KubeletConfiguration/a\
featureGates:\
  ClusterTrustBundle: true\
  ClusterTrustBundleProjection: true\
  PodCertificateRequest: true' /var/lib/kubelet/config.yaml
    needs_kubelet_restart=true
  fi

  # kube-apiserver only runs on control-plane nodes.
  if docker exec "${node}" test -f /etc/kubernetes/manifests/kube-apiserver.yaml && \
     ! docker exec "${node}" grep -q "PodCertificateRequest" /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null; then
    echo "Patching kube-apiserver manifest on node '${node}'..."
    docker exec "${node}" sed -i \
      -e 's|- --runtime-config=|- --runtime-config=certificates.k8s.io/v1beta1=true|' \
      -e "/- --etcd-servers=https:\/\/127.0.0.1:2379/a\\    - --feature-gates=${FEATURE_GATES}" \
      /etc/kubernetes/manifests/kube-apiserver.yaml
    needs_kubelet_restart=true
  fi

  if [ "${needs_kubelet_restart}" = true ]; then
    echo "Restarting kubelet on node '${node}' to apply the feature gates..."
    docker exec "${node}" systemctl restart kubelet
  fi
done

if ! kubectl --context="${KUBECTL_CONTEXT}" wait --for=condition=Ready node --all --timeout=120s >/dev/null 2>&1; then
  echo "warning: nodes did not report Ready within 120s after the feature-gate patch." >&2
fi

# 3. Add the registry config to the nodes
echo "Adding registry config to kind nodes..."
REGISTRY_DIR="/etc/containerd/certs.d/localhost:${reg_port}"
for node in $("${ROOT}"/hack/kind.sh get nodes --name "${KIND_CLUSTER_NAME}"); do
  docker exec "${node}" mkdir -p "${REGISTRY_DIR}"
  cat <<EOF | docker exec -i "${node}" cp /dev/stdin "${REGISTRY_DIR}/hosts.toml"
[host."http://${reg_name}:5000"]
EOF
done

# 4. Connect the registry to the cluster network if not already connected
echo "Connecting local registry to cluster network..."
if [ "$(docker inspect -f='{{json .NetworkSettings.Networks.kind}}' "${reg_name}")" = "null" ]; then
  docker network connect "kind" "${reg_name}"
fi

# 5. Document the local registry in kube-public ConfigMap
echo "Documenting local registry in cluster..."
cat <<EOF | kubectl --context="${KUBECTL_CONTEXT}" apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${reg_port}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF
