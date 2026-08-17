resource "helm_release" "centerstage" {
  repository = "../../../helm/infra/centerstage"
  name       = "centerstage"
  chart      = "../../../helm/infra/centerstage"
  namespace  = "dashboard"
  create_namespace = false

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }

  set {
    name  = "github.token"
    value = var.GITHUB_TOKEN
  }

  set_sensitive {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
  }

}