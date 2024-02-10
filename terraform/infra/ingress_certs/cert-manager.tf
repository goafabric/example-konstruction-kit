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

# we cannot use simple kubernetes manifest here, because the depends_on is not working and install fails with missing crds
resource "helm_release" "cert-manager-issuer" {
  depends_on = [helm_release.cert-manager]
  repository       = "./cert-manager-issuer/selfsigned" #var.hostname == "kind" ? "./cert-manager-issuer/selfsigned" : "./cert-manager-issuer/letsencrypt"
  name             = "cert-manager-issuer"
  chart            = "./cert-manager-issuer/selfsigned" #var.hostname == "kind" ? "./cert-manager-issuer/selfsigned" : "./cert-manager-issuer/letsencrypt"
  version          = "1.1.2"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}