resource "helm_release" "backstage" {
  repository = "../../../helm/infra/backstage"
  name       = "backstage"
  chart      = "../../../helm/infra/backstage"
  version    = "1.1.2"
  namespace  = "dashboard"
  create_namespace = false

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }

  set {
    name  = "argocd.auth.token"
    value = var.argocd_auth_token
  }

  set_sensitive {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
  }

}