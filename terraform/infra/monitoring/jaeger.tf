resource "helm_release" "jaeger" {
  repository = var.infra_repository
  name       = "jaeger-all"
  chart      = "${var.infra_repository}/06_monitoring/jaeger"
  version    = "1.46.0"
  namespace  = "monitoring"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}