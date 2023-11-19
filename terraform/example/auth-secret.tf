# for whatever stupid reason, nginx ingress also needs the secret here, if if only used inside monitoring ns
resource "kubernetes_namespace" "example" {
  metadata {
    name = "example"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubernetes_secret" "authentication-secret" {
  metadata {
    name = "authentication-secret"
    namespace = "example"
  }

  data = {
    "auth" = "admin:$apr1$opP9IMT.$3sY/kXyTRUvYcYrvkrcM5."
  }
}