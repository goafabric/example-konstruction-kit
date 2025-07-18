resource "random_password" "postgresql_password" {
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
    namespace = "example"
  }

  data = {
    username = "main"
    password = random_password.postgresql_password.result

    "spring.datasource.username" = "main"
    "spring.datasource.password" = random_password.postgresql_password.result

    "quarkus.datasource.username" = "main"
    "quarkus.datasource.password" = random_password.postgresql_password.result
  }

  type = "Opaque"
}