resource "helm_release" "welcome-board" {
  repository = "../../../../helm/templates/infra/welcome"
  name       = "welcome-board"
  chart      = "../../../../helm/templates/infra/welcome"
  version    = "1.1.2"
  namespace  = "default"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}