resource "helm_release" "welcome-board" {
  repository = var.infra_repository
  name       = "welcome-board"
  chart      = "welcome-board"
  version    = "1.1.1"
  namespace  = "default"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}