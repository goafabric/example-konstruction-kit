## kubernetes service account per namespace, might be better suited inside namespace creation

variable "namespaces" {
  type    = set(string)
  default = ["example", "core", "event", "invoice"]
}

resource "kubernetes_service_account" "vault_read_account" {
  for_each = var.namespaces

  metadata {
    name      = "vault-read-account"
    namespace = each.key
  }
}

## init hack

resource "terraform_data" "vault_operator_init_hack" {
  depends_on = [helm_release.vault]
  provisioner "local-exec" {
    command = <<EOT
    kubectl exec vault-0 -n vault -- /bin/sh -c 'vault operator init -key-shares=1 -key-threshold=1 > /vault/data/seals \
    && vault operator unseal $(grep "Unseal Key 1:" /vault/data/seals | awk "{print \$NF}")'
EOT
  }
}

## vault kubernetes auth bullshit

resource "terraform_data" "vault_k8s_config" {
  depends_on = [terraform_data.vault_operator_init_hack]
  provisioner "local-exec" {
    command = <<EOT
kubectl exec vault-0 -n vault -- /bin/sh -c '
export VAULT_TOKEN=$(grep "Initial Root Token:" /vault/data/seals | awk "{print \$NF}"); \
vault auth enable kubernetes; \
vault write auth/kubernetes/config \
  token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  kubernetes_host="https://$${KUBERNETES_PORT_443_TCP_ADDR}:443" \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
'
EOT
  }
}

# vault read role + policy
resource "terraform_data" "vault_read_role" {
  depends_on = [terraform_data.vault_k8s_config]
  provisioner "local-exec" {
    command = <<EOT
kubectl exec vault-0 -n vault -- /bin/sh -c '
export VAULT_TOKEN=$(grep "Initial Root Token:" /vault/data/seals | awk "{print \$NF}"); \
vault write auth/kubernetes/role/vault-read-role \
  bound_service_account_names=vault-read-account \
  bound_service_account_namespaces=* \
  policies=vault-read-policy \
'
EOT
  }
}

resource "terraform_data" "vault_read_policy" {
  depends_on = [terraform_data.vault_k8s_config]
  provisioner "local-exec" {
    command = <<EOT
kubectl exec vault-0 -n vault -- /bin/sh -c '
export VAULT_TOKEN=$(grep "Initial Root Token:" /vault/data/seals | awk "{print \$NF}"); \
vault secrets enable -path=databases -version=2; \
cat <<EOF > /home/vault/app-policy.hcl
path "databases/data/*" {
 capabilities = ["read"]
}
EOF
'
EOT
  }
}

## secrets





