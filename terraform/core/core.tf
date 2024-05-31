resource "helm_release" "core-application" {
  repository = var.helm_repository
  name       = "core-application"
  chart      = "${var.helm_repository}/core/application"
  namespace  = "core"
  create_namespace = true
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
    value = local.replica_count
  }

  set {
    name  = "database.password"
    value = random_password.core_database_password.result
  }
  set {
    name = "service.password"
    value = random_password.service_password.result
  }
  set {
    name  = "s3.password"
    value = random_password.s3_password.result
  }

  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }
  set {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
  }
}

resource "helm_release" "core-frontend" {
  repository       = var.helm_repository
  name             = "core-frontend"
  chart            = "${var.helm_repository}/core/frontend"
  namespace        = "core"
  create_namespace = true
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
  set {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
  }
}