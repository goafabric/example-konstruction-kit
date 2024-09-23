resource "helm_release" "event-dispatcher-service-application" {
  repository = var.helm_repository
  name       = "event-dispatcher-service-application"
  chart      = "${var.helm_repository}/event-dispatcher-service/application"
  namespace  = "event"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "image.arch"
    value = "-native${local.server_arch}"
  }
  set {
    name  = "replicaCount"
    value = "1"
  }
  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set_sensitive {
    name  = "messageBroker.password"
    value = "supersecret" #random_password.messageBroker_password.result
  }
  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }
}