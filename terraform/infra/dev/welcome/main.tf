provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "welcome-board" {
  repository = "${var.infra_repository}/welcome"
  name       = "welcome-board"
  chart      = "${var.infra_repository}/welcome"
  version    = "1.1.1"
  namespace  = "default"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}