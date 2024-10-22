# kubectl describe certificaterequest cluster-ca-1 -n cert-manager
resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.15.3"
  create_namespace = false

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
  create_namespace = false

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}

resource "terraform_data" "remove_certificate_secrets" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' | xargs -n 1 -I{} kubectl delete secret root-certificate --ignore-not-found -n {}"
  }
}