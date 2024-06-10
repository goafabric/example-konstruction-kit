resource "helm_release" "redis" {
  repository = var.helm_repository
  name       = "redis"
  chart      = "${var.helm_repository}/invoice-process/redis"
  namespace  = "invoice"
  create_namespace = true
  timeout = var.helm_timeout
}