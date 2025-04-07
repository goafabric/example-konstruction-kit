resource "helm_release" "callee-service-application" {
  repository = "./chart"
  name       = "my-service-application"
  chart      = "./chart/template"
  namespace  = "example"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "ingress.paths"
    value = "/callee"
  }

  set {
    name  = "image.fullName"
    value = "goafabric/callee-service:3.4.3"
  }

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }

  set {
    name = "oidc.enabled"
    value = false
  }

  set_sensitive {
    name = "oidc.session.secret"
    value = random_password.oidc_session_secret.result
  }


}