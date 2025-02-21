resource "helm_release" "keycloak" {
  depends_on = [helm_release.keycloak-postgres]

  repository = var.infra_repository
  name       = "keycloak-application"
  chart      = "${var.infra_repository}/keycloak/application"
  namespace  = "oidc"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }

  set {
    name  = "database.password"
    value = random_password.database_password.result
  }

  set {
    name  = "admin.password"
    value = random_password.admin_password.result
  }

  set {
    name  = "log.level"
    value = "INFO"
  }

}

resource "helm_release" "keycloak-postgres" {
  repository = var.infra_repository
  name       = "keycloak-postgres"
  chart      = "${var.infra_repository}/keycloak/postgres"
  namespace  = "oidc"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
}