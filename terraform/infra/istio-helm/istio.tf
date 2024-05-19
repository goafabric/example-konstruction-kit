resource "helm_release" "istio-base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
  create_namespace = true
  version    = "1.22.0"
  wait       = true

  set {
    name = "profile"
    value = "ambient"
  }
}

resource "helm_release" "istio-istiod" {
  name       = "istio-istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  create_namespace = true
  version    = "1.22.0"
  wait       = true

  depends_on = [helm_release.istio-base]

  set {
    name = "profile"
    value = "ambient"
  }
}

resource "helm_release" "istio-cni-kind" {
  count = local.production_mode == false ? 1 : 0

  name       = "istio-cni"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "cni"
  namespace  = "istio-system"
  create_namespace = true
  version    = "1.22.0"
  wait       = true

  depends_on = [helm_release.istio-base]

  set {
    name = "profile"
    value = "ambient"
  }
}

resource "helm_release" "istio-cni-microk8s" {
  count = local.production_mode == true ? 1 : 0

  name       = "istio-cni"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "cni"
  namespace  = "istio-system"
  create_namespace = true
  version    = "1.22.0"
  wait       = true

  depends_on = [helm_release.istio-base]

  set {
    name = "profile"
    value = "ambient"
  }
  set {
    name = "cni.cniBinDir"
    value = "/var/snap/microk8s/current/opt/cni/bin"
  }
  set {
    name = "cni.cniConfDir"
    value = "/var/snap/microk8s/current/args/cni-network"
  }
}

resource "helm_release" "istio-ztunnel" {
  name       = "istio-ztunnel"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "ztunnel"
  namespace  = "istio-system"
  create_namespace = true
  version    = "1.22.0"
  wait       = true

  depends_on = [helm_release.istio-base]
}