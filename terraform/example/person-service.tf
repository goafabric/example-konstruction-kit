resource "helm_release" "person-service-application" {
  repository = var.helm_repository
  name       = "person-service-application"
  chart      = "${var.helm_repository}/person-service/application"
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

  set {
    name = "multiTenancy.tenants"
    value = var.multi_tenancy_tenants
  }

  set_sensitive {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
  }

  set_sensitive {
    name  = "database.password"
    value = random_password.postgresql_password.result
  }
}


