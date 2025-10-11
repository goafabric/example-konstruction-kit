resource "helm_release" "backstage" {
  repository = "../../../helm/infra/backstage"
  name       = "backstage"
  chart      = "../../../helm/infra/backstage"
  version    = "1.1.2"
  namespace  = "dashboard"
  create_namespace = false

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}