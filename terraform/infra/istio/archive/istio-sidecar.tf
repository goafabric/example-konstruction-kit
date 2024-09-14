resource "helm_release" "istio-base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
  create_namespace = false
  version    = "1.23.1"
  wait       = true
}

resource "helm_release" "istio-istiod" {
  name       = "istio-istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  create_namespace = false
  version    = "1.23.1"
  wait       = true

  depends_on = [helm_release.istio-base]
}

//kubectl label namespace ingress-apisix istio-injection=enabled --overwrite && kubectl label namespace kong istio-injection=enabled
//kubectl label namespace example istio-injection=enabled --overwrite && kubectl label namespace core istio-injection=enabled --overwrite

//kubectl label namespace ingress-apisix istio.io/dataplane-mode=ambient