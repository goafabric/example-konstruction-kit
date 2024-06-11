resource "helm_release" "welcome-board" {
  repository = "../../../helm/infra/welcome"
  name       = "welcome-board"
  chart      = "../../../helm/infra/welcome"
  version    = "1.1.2"
  namespace  = "dashboard"
  create_namespace = false

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}