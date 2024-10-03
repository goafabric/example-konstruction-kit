provider "vault" {
  address = "http://localhost:30800"
}

resource "random_password" "database_password" {
  length           = 32
  special          = false
}

resource "random_password" "minio_password" {
  length           = 32
  special          = false
}

resource "random_password" "redis_password" {
  length           = 32
  special          = false
}

resource "random_password" "kafka_password" {
  length           = 32
  special          = false
}

resource "vault_kv_secret_v2" "vault-secret-person-service-postgres" {
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


resource "vault_kv_secret_v2" "vault-secret-invoice-redis" {
  mount                      = "databases"
  name                       = "invoice-redis"
  cas                        = 1
  delete_all_versions        = true

  data_json = jsonencode({
#    REDIS_PASSWORD: random_password.redis_password.result
#    REDIS_MASTER_PASSWORD: random_password.redis_password.result

    "spring.data.redis.password": random_password.redis_password.result
    "spring.data.redis.sentinel.password": random_password.redis_password.result
  })
}


resource "vault_kv_secret_v2" "vault-secret-event-kafka" {
  mount                      = "databases"
  name                       = "event-kafka"
  cas                        = 1
  delete_all_versions        = true


  data_json = jsonencode({
#    KAFKA_CLIENT_PASSWORDS: random_password.kafka_password.result
#    KAFKA_INTER_BROKER_PASSWORD=
#    KAFKA_CONTROLLER_PASSWORD=

    "spring.kafka.username": "admin"
    "spring.kafka.password": random_password.kafka_password.result
  })
}