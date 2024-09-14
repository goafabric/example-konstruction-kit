resource "helm_release" "istio-base-sidecar" {
  count = local.istio_mode== "sidecar" ? 1 : 0

  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
  create_namespace = false
  version    = "1.23.1"
  wait       = true
}

resource "helm_release" "istio-istiod-sidecar" {
  count = local.istio_mode== "sidecar" ? 1 : 0

  name       = "istio-istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  create_namespace = false
  version    = "1.23.1"
  wait       = true

  depends_on = [helm_release.istio-base]
}

//kubectl label namespace ingress-apisix istio-injection=enabled
//kubectl label namespace example istio-injection=enabled && kubectl label namespace core istio-injection=enabled