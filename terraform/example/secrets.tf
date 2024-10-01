provider "vault" {
  address = "http://localhost:30800"
}

resource "random_password" "database_password" {
  length           = 32
  special          = false
}

resource "vault_kv_secret_v2" "vault-person-service-postgres" {
  mount                      = "databases"
  name                       = "person-service-postgres"
  cas                        = 1
  delete_all_versions        = true

  data_json = jsonencode({
    POSTGRES_USER = "person-service"
    POSTGRES_PASSWORD = random_password.database_password.result
    "spring.datasource.username" = "person-service"
    "spring.datasource.password" = random_password.database_password.result
  })
}