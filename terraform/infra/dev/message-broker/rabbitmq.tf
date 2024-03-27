resource "helm_release" "rabbitmq" {
  repository = var.helm_repository
  name       = "rabbitmq"
  chart      = "${var.helm_repository}/rabbitmq/application"
  version    = "3.12.1"
  namespace  = "message-broker"
  create_namespace = true
  timeout = var.helm_timeout
}