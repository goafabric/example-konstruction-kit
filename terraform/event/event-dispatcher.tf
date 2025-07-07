resource "helm_release" "event-dispatcher-service-application" {
  repository = var.helm_repository
  name       = "event-dispatcher-service-application"
  chart      = "${var.helm_repository}/event-dispatcher-service/application"
  namespace  = "event"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }

}