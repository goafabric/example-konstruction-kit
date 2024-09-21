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

# kubectl -n vault port-forward svc/vault 8200:8200

# kubectl exec --stdin=true --tty=true vault-0 -n vault -- /bin/sh
# vault operator init
# vault operator unseal 5 times

# vault login
# vault auth enable kubernetes

## injection config
vault write auth/kubernetes/config \
token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
kubernetes_host="https://${KUBERNETES_PORT_443_TCP_ADDR}:443" \
kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

## https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/hashicorp/vault-2022/example-apps/basic-secret

kubectl -n example apply -f ./example-apps/deployment.yaml
kubectl -n example get pods

cat /vault/secrets/helloworld

kubectl -n example delete -f ./example-apps/deployment.yaml