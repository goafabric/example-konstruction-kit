resource "helm_release" "welcome-board" {
  repository = var.infra_repository
  name       = "welcome-board"
  chart      = "${var.infra_repository}/10_welcome"
  version    = "1.1.1"
  namespace  = "default"
  create_namespace = false

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}