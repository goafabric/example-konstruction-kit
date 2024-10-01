resource "random_password" "database_password" {
  length           = 32
  special          = false
}


resource "vault_kv_secret_v2" "vault-example-service-postgres" {
  depends_on = [vault_mount.databases]

  mount                      = "databases"
  name                       = "example-service-postgres"
  cas                        = 1
  delete_all_versions        = true

  data_json = jsonencode({
    POSTGRES_USER = "example-service"
    POSTGRES_PASSWORD = random_password.database_password.result
    "spring.datasource.username" = "example-service"
    "spring.datasource.password" = random_password.database_password.result
  })
}