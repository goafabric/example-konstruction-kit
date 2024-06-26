resource "helm_release" "event-dispatcher-service-application" {
  repository = var.helm_repository
  name       = "event-dispatcher-service-application"
  chart      = "${var.helm_repository}/event-dispatcher-service/application"
  namespace  = "event"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "replicaCount"
    value = "1"
  }
  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "messageBroker.password"
    value = random_password.messageBroker_password.result
  }
  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }
  set {
    name = "dispatcher.profile"
    value = local.dispatcher_profile
  }
  set {
    name  = "image.arch"
    value = local.dispatcher_profile == "kafka" ? "-native${local.server_arch}" : ""
  }
}