resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.13.1"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "prometheus.enabled"
    value = "false"
  }

  set {
    name  = "extraArgs[0]"
    value = "--enable-certificate-owner-ref"
  }
}

resource "helm_release" "cert-manager-issuer" {
  depends_on = [helm_release.cert-manager]
  repository       = "./resources"
  name             = "cert-manager-issuer"
  chart            = "./resources"
  version          = "1.1.1"
  namespace        = "example"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}