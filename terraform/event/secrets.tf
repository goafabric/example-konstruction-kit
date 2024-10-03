provider "vault" {
  address = "http://localhost:30800"
}

resource "random_password" "kafka_client_password" {
  length           = 32
  special          = false
}

resource "random_password" "kafka_system_password" {
  length           = 32
  special          = false
}


resource "vault_kv_secret_v2" "vault-secret-event-kafka" {
  mount                      = "databases"
  name                       = "event-kafka"
  cas                        = 1
  delete_all_versions        = true


  data_json = jsonencode({
    KAFKA_CLIENT_USERS: "admin"
    KAFKA_CLIENT_PASSWORDS: random_password.kafka_client_password.result

    KAFKA_INTER_BROKER_PASSWORD: random_password.kafka_system_password.result
    KAFKA_CONTROLLER_PASSWORD: random_password.kafka_system_password.result

    "spring.kafka.username": "admin"
    "spring.kafka.password": random_password.kafka_client_password.result
  })
}