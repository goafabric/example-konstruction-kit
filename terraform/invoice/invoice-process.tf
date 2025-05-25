resource "helm_release" "invoice-process-application" {
  #depends_on = [helm_release.redis]
  repository = var.helm_repository
  name       = "invoice-process-application"
  chart      = "${var.helm_repository}/invoice-process/application"
  namespace  = "invoice"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "maxReplicas"
    value = "3"
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
    name = "oidc.enabled"
    value = local.oidc_enabled
  }
  set_sensitive {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
  }
  set {
    name = "cache.type"
    value = local.cache_type
  }

  set_sensitive {
    name  = "s3.password"
    value = data.kubernetes_secret.s3.data["root-password"]
  }
  
  set_sensitive {
    name  = "redis.password"
    value = random_password.cache_password.result
  }

}
