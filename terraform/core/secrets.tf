provider "vault" {
  address = "http://localhost:30800"
}

resource "random_password" "postgres_password" {
  length           = 32
  special          = false
}

resource "random_password" "minio_password" {
  length           = 32
  special          = false
}

resource "vault_kv_secret_v2" "vault-secret-core-service-postgres" {
  mount                      = "databases"
  name                       = "core-service-postgres"
  cas                        = 1
  delete_all_versions        = true

  data_json = jsonencode({
    POSTGRES_USER = "core-service"
    POSTGRES_PASSWORD = random_password.postgres_password.result
    "spring.datasource.username" = "core-service"
    "spring.datasource.password" = random_password.postgres_password.result
  })
}

resource "vault_kv_secret_v2" "vault-secret-core-minio" {
  mount                      = "databases"
  name                       = "core-minio"
  cas                        = 1
  delete_all_versions        = true

  data_json = jsonencode({
    MINIO_ROOT_USER = "minioadmin"
    MINIO_ROOT_PASSWORD = random_password.minio_password.result

    "spring.cloud.aws.credentials.access-key": "minioadmin"
    "spring.cloud.aws.credentials.secret-key": random_password.minio_password.result

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

