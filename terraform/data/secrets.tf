resource "random_password" "postgresql_password" {
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

resource "kubernetes_secret" "postgresql_secret" {
  metadata {
    name      = "postgresql-secret"
    namespace = "data"
  }

  data = {
    username = "main"
    password = random_password.postgresql_password.result
  }

  type = "Opaque"
}

resource "kubernetes_secret" "s3_secret" {
  metadata {
    name      = "s3-secret"
    namespace = "data"
  }

  data = {
    username = "minioadmin"
    password = random_password.s3_password.result
  }

  type = "Opaque"
}