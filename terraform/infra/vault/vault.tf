resource "helm_release" "vault" {
  name       = "vault"
  chart      = "vault"
  namespace  = "vault"
  repository = "https://helm.releases.hashicorp.com"
  create_namespace = true
  version    = "0.28.1"

  set {
    name  = "server.ha.enabled"
    value = "false"
  }

  set {
    name  = "server.dev.enabled"
    value = "true"
  }

  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "server.service.nodePort"
    value = "30800"
  }

}

# resource "helm_release" "vault-secrets-operator" {
#   name       = "vault-secrets-operator"
#   chart      = "vault-secrets-operator"
#   namespace  = "vault"
#   repository = "https://helm.releases.hashicorp.com"
#   create_namespace = true
#   version    = "0.8.1"
#
# }


# banzai bank vault webhook combined with hashicorp vault
resource "helm_release" "vault-secrets-webhook" {
  name       = "vault-secrets-webhook"
  chart      = "vault-secrets-webhook"
  namespace  = "vault"
  repository = "oci://ghcr.io/bank-vaults/helm-charts"
  create_namespace = true
}


resource "terraform_data" "create_stack" {
  depends_on = [helm_release.vault]
  provisioner "local-exec" {
    when    = create
    command = "./stack up"
  }
}

