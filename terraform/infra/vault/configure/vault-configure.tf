provider "vault" {
  address = "http://localhost:30800"
}

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

## vault kubernetes auth bullshit

# resource "vault_auth_backend" "kubernetes" {
#   #depends_on = [helm_release.vault]
#
#   type = "kubernetes"
#   path = "kubernetes"
# }

resource "terraform_data" "vault_k8s_config" {
  #depends_on = [vault_auth_backend.kubernetes]
  provisioner "local-exec" {
    command = <<EOT
kubectl exec vault-0 -n vault -- /bin/sh -c '
export VAULT_TOKEN=hvs.5Eop6jpcqrrdpTbiC4bV8N63 && vault auth enable kubernetes && \
vault write auth/kubernetes/config \
  token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  kubernetes_host="https://$${KUBERNETES_PORT_443_TCP_ADDR}:443" \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
'
EOT
  }
}

# vault read role + policy

resource "vault_kubernetes_auth_backend_role" "vault_read_role" {
  depends_on = [terraform_data.vault_k8s_config]

  role_name     = "vault-read-role"
  backend       = "kubernetes"
  token_policies = ["vault-read-policy"]

  bound_service_account_names      = ["vault-read-account"]
  bound_service_account_namespaces = ["*"]
}

resource "vault_policy" "vault_read_policy" {
  depends_on = [terraform_data.vault_k8s_config]
  name = "vault-read-policy"

  policy = <<EOT
# Allow login via Kubernetes auth method
path "auth/kubernetes/login" {
  capabilities = ["create", "update"]
}

# Allow read access to the database secrets
path "databases/data/*" {
  capabilities = ["read"]
}
EOT
}

## secrets

resource "vault_mount" "databases" {
  depends_on = [terraform_data.vault_k8s_config]

  path        = "databases"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}




