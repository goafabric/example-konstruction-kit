resource "helm_release" "kafka" {
  count = local.dispatcher_profile == "kafka" ? 1 : 0

  repository = var.helm_repository
  name       = "kafka"
  chart      = "${var.helm_repository}/kafka/application"
  namespace  = "event"
  create_namespace = true
  timeout = var.helm_timeout

  #  set {
  #     name  = "messageBroker.password"
  #     value = random_password.database_password.result
  #   }
}