provider "vault" {
  address = "http://localhost:30800"
}

resource "random_password" "database_password" {
  length           = 32
  special          = false
}

resource "vault_kv_secret_v2" "vault-core-service-postgres" {
  mount                      = "databases"
  name                       = local.postgres_secret_path
  cas                        = 1
  delete_all_versions        = true

  data_json = jsonencode({
    POSTGRES_USER = "core-service"
    POSTGRES_PASSWORD = random_password.database_password.result
    "spring.datasource.username" = "core-service"
    "spring.datasource.password" = random_password.database_password.result
  })
}

resource "random_password" "s3_password" {
  length           = 32
  special          = false
}

resource "random_password" "oidc_session_secret" {
  length           = 32
  special          = false
}

