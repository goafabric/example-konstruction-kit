resource "random_password" "postgresql_password" {
  length           = 32
  special          = false
}

resource "random_password" "oidc_session_secret" {
  length           = 32
  special          = false
}


resource "kubernetes_secret" "image_registry_secret" {
  metadata {
    name      = "image-registry-secret"
    namespace = "core"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        (var.image_registry) = {
          "auth" = base64encode("${var.image_registry_user}:${var.image_registry_password}")
        }
      }
    })
  }
}