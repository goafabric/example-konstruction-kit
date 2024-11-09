resource "helm_release" "istio-base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
  create_namespace = false
  version    = "1.24.0"
  wait       = true

  set {
    name = "profile"
    value = local.istio_mode== "ambient" ? "ambient" : ""
  }
}

resource "helm_release" "istio-istiod" {
  name       = "istio-istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  create_namespace = false
  version    = "1.24.0"
  wait       = true

  depends_on = [helm_release.istio-base]

  set {
    name = "profile"
    value = local.istio_mode== "ambient" ? "ambient" : ""
  }
}


resource "helm_release" "istio-cni" {
  count = local.istio_mode== "ambient" ? 1 : 0

  name       = "istio-cni"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "cni"
  namespace  = "istio-system"
  create_namespace = false
  version    = "1.24.0"
  wait       = true

  depends_on = [helm_release.istio-base]

  set {
    name = "profile"
    value = "ambient"
  }
}

resource "helm_release" "istio-ztunnel" {
  count = local.istio_mode== "ambient" ? 1 : 0

  name       = "istio-ztunnel"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "ztunnel"
  namespace  = "istio-system"
  create_namespace = false
  version    = "1.24.0"
  wait       = true

  depends_on = [helm_release.istio-base]
}

//uninstall crd
//kubectl get crd -oname | grep --color=never 'istio.io' | xargs kubectl delete
