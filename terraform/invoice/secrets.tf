resource "random_password" "cache_password" {
  length           = 32
  special          = false
}

resource "random_password" "oidc_session_secret" {
  length           = 32
  special          = false
}

data "kubernetes_secret" "s3_secret" {
  metadata {
    name      = "s3-secret"
    namespace = "data"
  }
}