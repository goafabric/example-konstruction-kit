provider "vault" {
  address = "http://localhost:30800"
  token   = "root"
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

resource "vault_auth_backend" "kubernetes" {
  depends_on = [helm_release.vault]

  type = "kubernetes"
  path = "kubernetes"
}

resource "terraform_data" "vault_k8s_config" {
  depends_on = [vault_auth_backend.kubernetes]
  provisioner "local-exec" {
    command = <<EOT
kubectl exec -it vault-0 -n vault -- /bin/sh -c '
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

resource "terraform_data" "secret-example-service-postgres" {
  depends_on = [vault_mount.databases]
  provisioner "local-exec" {
    command = <<EOT
kubectl exec -it vault-0 -n vault -- sh -c 'U=person-service;P=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | sha256sum | base64 | head -c 32);
  vault kv put databases/example-service-postgres POSTGRES_USER=$U POSTGRES_PASSWORD=$P spring.datasource.username=$U spring.datasource.password=$P;'
EOT
  }
}

resource "terraform_data" "secret-person-service-postgres" {
  depends_on = [vault_mount.databases]
  provisioner "local-exec" {
    command = <<EOT
kubectl exec -it vault-0 -n vault -- sh -c 'U=person-service;P=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | sha256sum | base64 | head -c 32);
  vault kv put databases/person-service-postgres POSTGRES_USER=$U POSTGRES_PASSWORD=$P spring.datasource.username=$U spring.datasource.password=$P;'
EOT
  }
}

# resource "vault_kv_secret_v2" "secret-example-service-postgres" {
#   depends_on = [vault_mount.databases]
#
#   mount                      = vault_mount.kvv2.path
#   name                       = "databases/example-service-postgres"
#   cas                        = 1
#   delete_all_versions        = true
#
#
#   data_json = jsonencode({
#     POSTGRES_USER = "example-service"
#     POSTGRES_PASSWORD = "sUp3rS3cUr3Passw0rd"
#     "spring.datasource.username" = "example-service"
#     "spring.datasource.password" = "sUp3rS3cUr3Passw0rd"
#   })
# }
#
#
# resource "vault_kv_secret" "secret-person-service-postgres" {
#   depends_on = [vault_mount.databases]
#
#   path = "databases/data/person-service-postgres"
#
#   data_json = jsonencode({
#     data = {
#       POSTGRES_USER = "person-service"
#       POSTGRES_PASSWORD = random_password.database_password.result
#       "spring.datasource.username" = "person-service"
#       "spring.datasource.password" = random_password.database_password.result
#     }
#   })
# }



