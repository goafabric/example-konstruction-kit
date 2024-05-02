resource "helm_release" "event-dispatcher-service-application" {
  repository = var.helm_repository
  name       = "event-dispatcher-service-application"
  chart      = "${var.helm_repository}/event-dispatcher-service/application"
#  version    = "1.1.2"
  namespace  = "message-broker"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "replicaCount"
    value = local.replica_count
  }

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image.arch"
    value = "-native${local.server_arch}"
  }
  set {
    name  = "messageBroker.password"
    value = random_password.database_password.result
  }
  set {
    name = "authentication.enabled"
    value = local.authentication_enabled
  }
}