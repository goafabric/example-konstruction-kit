resource "helm_release" "dragonfly" {
  count = local.cache_type == "dragonfly" ? 1 : 0

  name       = "dragonfly"
  repository = "oci://ghcr.io/dragonflydb/dragonfly/helm"
  chart      = "dragonfly"
  namespace  = "invoice"
  version    = "v1.27.2"

  set {
    name  = "replicaCount"
    value = local.cache_replica_count
  }

  set {
    name  = "commonLabels.app"
    value = "dragonfly"
  }
}

