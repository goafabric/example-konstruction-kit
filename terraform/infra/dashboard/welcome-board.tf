resource "helm_release" "welcome-board" {
  repository = "../../../helm/infra/welcome"
  name       = "welcome-board"
  chart      = "../../../helm/infra/welcome"
  version    = "1.1.2"
  namespace  = "monitoring"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}