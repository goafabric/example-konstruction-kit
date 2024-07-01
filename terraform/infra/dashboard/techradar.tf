resource "helm_release" "tech-radar" {
  repository = "../../../helm/infra/techradar"
  name       = "tech-radar"
  chart      = "../../../helm/infra/techradar"
  version    = "1.1.2"
  namespace  = "dashboard"
  create_namespace = false

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}