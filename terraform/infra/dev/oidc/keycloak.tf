resource "helm_release" "keycloak" {
  depends_on = [helm_release.keycloak-postgres]

  repository = var.infra_repository
  name       = "keycloak-application"
  chart      = "${var.infra_repository}/keycloak/application"
  version    = "1.1.2"
  namespace  = "oidc"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}

resource "helm_release" "keycloak-postgres" {
  repository = var.infra_repository
  name       = "keycloak-postgres"
  chart      = "${var.infra_repository}/keycloak/postgres"
  version    = "1.1.2"
  namespace  = "oidc"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}