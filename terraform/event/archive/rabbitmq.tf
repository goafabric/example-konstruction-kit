resource "helm_release" "rabbitmq" {
  count = local.dispatcher_profile == "rabbitmq" ? 1 : 0

  repository = var.helm_repository
  name       = "rabbitmq"
  chart      = "${var.helm_repository}/rabbitmq/application"
  namespace  = "event"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "messageBroker.password"
    value = random_password.messageBroker_password.result
  }
}
