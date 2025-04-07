resource "helm_release" "callee-service-application" {
  repository = "./chart"
  name       = "callee-service-application"
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
    name  = "database.password"
    value = random_password.postgresql_password.result
  }


}