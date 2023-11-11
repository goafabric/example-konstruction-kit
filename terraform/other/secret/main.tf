provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_secret" "authentication-secret" {
  metadata {
    name = "authentication-secret"
    namespace = "monitoring"
  }

  data = {
    "auth" = "${file("${path.module}/config/auth")}"
  }
}