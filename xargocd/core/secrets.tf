resource "random_password" "oidc_session_secret" {
  length           = 32
  special          = false
}

data "kubernetes_secret" "postgresql" {
  metadata {
    name      = "postgresql"
    namespace = "data"
  }
}

data "kubernetes_secret" "s3" {
  metadata {
    name      = "s3-minio"
    namespace = "data"
  }
}