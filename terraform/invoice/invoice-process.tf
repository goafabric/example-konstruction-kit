resource "helm_release" "invoice-process-application" {
  #depends_on = [helm_release.redis]
  repository = var.helm_repository
  name       = "invoice-process-application"
  chart      = "${var.helm_repository}/invoice-process/application"
  namespace  = "invoice"
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

  set {
    name = "cache.type"
    value = local.cache_type
  }

  # secrets
  set_sensitive {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
  }


}
