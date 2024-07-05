resource "helm_release" "catalog-application" {
  depends_on = [helm_release.catalog-batch]
  repository = var.helm_repository
  name       = "catalog-application"
  chart      = "${var.helm_repository}/catalog/application"
  namespace  = "core"
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
    name  = "image.arch"
    value = "-native${local.server_arch}"
  }

  set {
    name  = "database.password"
    value = random_password.core_database_password.result
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

resource "helm_release" "catalog-batch" {
  repository = var.helm_repository
  name       = "catalog-batch"
  chart      = "${var.helm_repository}/catalog/batch"
  version    = "1.1.2"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "image.arch"
    value = "-native${local.server_arch}"
  }
  set {
    name  = "database.password"
    value = random_password.core_database_password.result
  }
  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }
}