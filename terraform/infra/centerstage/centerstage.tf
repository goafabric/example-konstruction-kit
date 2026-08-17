resource "helm_release" "centerstage" {
  repository = "../../../helm/infra/centerstage"
  name       = "centerstage"
  chart      = "../../../helm/infra/centerstage"
  namespace  = "dashboard"
  create_namespace = false
  timeout = 30

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }

  set {
    name  = "github.token"
    value = var.github_token
  }

  set_sensitive {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
  }

}