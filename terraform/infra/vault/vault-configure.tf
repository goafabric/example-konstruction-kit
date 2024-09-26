provider "vault" {
  address = "http://localhost:30800"
  token   = "root"
}

resource "vault_auth_backend" "kubernetes" {
  depends_on = [helm_release.vault]

  type = "kubernetes"
  path = "kubernetes"
}

resource "terraform_data" "vault_k8s_config" {
  depends_on = [helm_release.vault]
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


resource "kubernetes_service_account" "vault_read_account" {
  metadata {
    name = "vault-read-account"
  }
}


resource "vault_kubernetes_auth_backend_role" "vault_read_role" {
  depends_on = [helm_release.vault]

  role_name     = "vault-read-role"
  backend       = "kubernetes"
  token_policies = ["vault-read-policy"]

  bound_service_account_names      = ["vault-read-account"]
  bound_service_account_namespaces = ["*"]
}

resource "vault_policy" "vault_read_policy" {
  depends_on = [helm_release.vault]
  name = "vault-read-policy"

  policy = <<EOT
path "secret/data/database/*" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kv_secret" "my_secret" {
  depends_on = [helm_release.vault]
  path = "secret/data/database/person-service-postgres"

  data_json = jsonencode({
    data = {
      POSTGRES_USER = "person-service"
      POSTGRES_PASSWORD = "sUp3rS3cUr3Passw0rd"
      "spring.datasource.username" = "person-service"
      "spring.datasource.password" = "sUp3rS3cUr3Passw0rd"
    }
  })
}



