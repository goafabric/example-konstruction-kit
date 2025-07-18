resource "helm_release" "catalog-application" {
  #depends_on = [helm_release.catalog-batch]
  repository = var.helm_repository
  name       = "catalog-application"
  chart      = "${var.helm_repository}/catalog/application"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout
  force_update = true

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

resource "helm_release" "catalog-batch" {
  repository = var.helm_repository
  name       = "catalog-batch"
  chart      = "${var.helm_repository}/catalog/batch"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "image.arch"
    value = "-native"
  }

  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }
}