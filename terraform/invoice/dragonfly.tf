resource "helm_release" "dragonfly" {
  name       = "dragonfly"
  repository = "oci://ghcr.io/dragonflydb/dragonfly/helm"
  chart      = "dragonfly"
  namespace  = "invoice"
  version    = "v1.27.2"

}

