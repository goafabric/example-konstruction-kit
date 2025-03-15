resource "helm_release" "core-application" {
  repository = var.helm_repository
  name       = "core-application"
  chart      = "${var.helm_repository}/core/application"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "image.arch"
    value = "-native${local.server_arch}"
  }
  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "replicaCount"
    value = "1"
  }

  set_sensitive {
    name  = "database.password"
    value = random_password.core_database_password.result
  }

  set_sensitive {
    name  = "s3.password"
    value = "minioadmin" #random_password.s3_password.result
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
    name = "kafka.enabled"
    value = "true"
  }
  set {
    name  = "messageBroker.password"
    value = "supersecret" #random_password.messageBroker_password.result
  }
  set {
    name = "multiTenancy.tenants"
    value = var.multi_tenancy_tenants
  }

}

resource "helm_release" "core-frontend" {
  repository       = var.helm_repository
  name             = "core-frontend"
  chart            = "${var.helm_repository}/core/frontend"
  namespace        = "core"
  create_namespace = false
  timeout          = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "replicaCount"
    value = "1"
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