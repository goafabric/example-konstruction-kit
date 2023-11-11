resource "kubernetes_secret" "authentication-secret" {
  metadata {
    name = "authentication-secret"
    namespace = "monitoring"
  }

  data = {
    "auth" = "admin:$apr1$opP9IMT.$3sY/kXyTRUvYcYrvkrcM5."
  }
}