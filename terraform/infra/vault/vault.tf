resource "helm_release" "hashicorp_vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com/"
  chart      = "hashicorp/vault"
  namespace  = "vault"
  create_namespace = true
  version    = "0.28.1"

  set {
    name  = "server.ha.enabled"
    value = "false"
  }

}


#helm repo add hashicorp https://helm.releases.hashicorp.com
#helm install vault hashicorp/vault --namespace vault --create-namespace --version 0.28.1

#helm uninstall vault --namespace vault