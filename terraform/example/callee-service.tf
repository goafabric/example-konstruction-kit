resource "helm_release" "callee-service-application" {
  repository = var.helm_repository
  name       = "callee-service-application"
  chart      = "${var.helm_repository}/callee-service/application"
  namespace  = "example"
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

  set_sensitive {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
  }
}