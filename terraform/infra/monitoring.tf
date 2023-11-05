resource "helm_release" "jaeger" {
  repository = var.infra_repository
  name       = "jaeger-all"
  chart      = "jaeger-all"
  version    = "1.46.0"
  namespace  = "monitoring"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}

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