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