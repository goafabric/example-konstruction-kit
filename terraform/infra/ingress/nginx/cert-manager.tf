resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.14.4"
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

#   set {
#     name  = "startupapicheck.enabled"
#     value = "false"
#   }
}


# we cannot use simple kubernetes manifest here, because the depends_on is not working and install fails with missing crds
resource "helm_release" "cert-manager-issuer" {
  depends_on = [helm_release.cert-manager]
  repository       = local.cert_manager_issuer
  name             = "cert-manager-issuer"
  chart            = local.cert_manager_issuer
  version          = "1.1.2"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}