resource "random_password" "postgresql_password" {
  length           = 32
  special          = false
}

resource "random_password" "kafka_password" {
  length           = 32
  special          = false
}

resource "random_password" "s3_password" {
  length           = 32
  special          = false
}

resource "random_password" "oidc_session_secret" {
  length           = 32
  special          = false
}

variable "namespaces" {
  type    = list(string)
  default = ["data", "core", "event", "invoice", "example"]
}

resource "kubernetes_secret" "postgresql_secret" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "postgresql-secret"
    namespace = each.key
  }

  data = {
    username = "main"
    password = random_password.postgresql_password.result

    "spring.datasource.username" = "main"
    "spring.datasource.password" = random_password.postgresql_password.result
  }

  type = "Opaque"
}


resource "kubernetes_secret" "s3_secret" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "s3-secret"
    namespace = each.key
  }

  data = {
    username = "minioadmin"
    password = random_password.s3_password.result

    "spring.cloud.aws.credentials.access-key" = "minioadmin"
    "spring.cloud.aws.credentials.secret-key" = random_password.s3_password.result
  }

  type = "Opaque"
}

resource "kubernetes_secret" "kafka_secret" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "kafka-secret"
    namespace = each.key
  }

  data = {
    username = "admin"
    password = random_password.kafka_password.result

    "spring.kafka.username" = "admin"
    "spring.kafka.password" = random_password.kafka_password.result
  }

  type = "Opaque"
}