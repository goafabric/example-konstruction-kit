resource "helm_release" "vault" {
  name       = "vault"
  chart      = "vault"
  namespace  = "vault"
  repository = "https://helm.releases.hashicorp.com"
  create_namespace = false
  version    = "0.28.1"

  set {
    name  = "server.ha.enabled"
    value = false
  }
  set {
    name  = "server.ha.raft.enabled"
    value = false
  }
  set {
    name  = "server.ha.replicas"
    value = "3"
  }
  set {
    name  = "server.dev.enabled"
    value = false
  }
  set {
    name  = "injector.enabled"
    value = false
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

# banzai bank vault webhook combined with hashicorp vault for environment injection
resource "helm_release" "vault-secrets-webhook" {
  name       = "vault-secrets-webhook"
  chart      = "vault-secrets-webhook"
  namespace  = "vault"
  repository = "oci://ghcr.io/bank-vaults/helm-charts"
  version    = "1.21.3"

  create_namespace = false
}

resource "terraform_data" "vault_operator_init" {
  depends_on = [helm_release.vault]
  provisioner "local-exec" {
    command = <<EOT
    while [ $(kubectl get pod vault-0 -n vault -o 'jsonpath={.status.phase}') != "Running" ]; do sleep 1; done;
    kubectl exec vault-0 -n vault -- /bin/sh -c 'INIT_OUTPUT=$(vault operator init -key-shares=1 -key-threshold=1) \
    && vault operator unseal $(echo "$INIT_OUTPUT" | grep "Unseal Key 1:" | awk "{print \$NF}") \
    && echo "$INIT_OUTPUT"' > ~/.vault/seals-$TF_VAR_hostname # not meant for production, will dump the seals to a local file
EOT
  }
}

resource "terraform_data" "remove_vault_pvc" {
  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=vault -n vault"
  }
}

# vault unseal
# kubectl exec vault-0 -n vault -- /bin/sh -c 'vault operator unseal $(grep "Unseal Key 1:" /vault/data/seals | awk "{print \$NF}")'

