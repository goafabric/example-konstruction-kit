resource "helm_release" "core-application" {
  repository = var.helm_repository
  name       = "core-application"
  chart      = "${var.helm_repository}/core/application"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout

  values = [
    file("../../helm/values.yaml")
  ]

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }

  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }

  # secrets
  set_sensitive {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
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
    name  = "maxReplicas"
    value = "3"
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