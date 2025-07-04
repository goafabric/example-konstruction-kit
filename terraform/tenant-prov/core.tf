resource "helm_release" "core-provisioning" {
  repository = var.helm_repository
  name       = "core-provisioning"
  chart      = "${var.helm_repository}/core/provisioning"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }

  set {
    name = "multiTenancy.tenants"
    value = var.multi_tenancy_tenants
  }

  # secrets
  set {
    name  = "messageBroker.password"
    value = "supersecret"
  }

  set_sensitive {
    name  = "database.password"
    value = data.kubernetes_secret.postgresql_secret.data["password"]
  }

  set_sensitive {
    name  = "s3.password"
    value = data.kubernetes_secret.s3_secret.data["password"]
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