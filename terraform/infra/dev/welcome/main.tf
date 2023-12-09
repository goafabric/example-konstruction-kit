provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "welcome-board" {
  repository = "./chart"
  name       = "welcome-board"
  chart      = "./chart"
  version    = "1.1.1"
  namespace  = "default"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}