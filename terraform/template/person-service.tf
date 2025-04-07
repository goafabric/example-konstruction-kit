resource "helm_release" "person-service-application" {
  repository = "./chart"
  name       = "person-service-application"
  chart      = "./chart/template"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "ingress.paths"
    value = "/person"
  }

  set {
    name  = "image.fullName"
    value = "goafabric/person-service:3.4.3"
  }

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }

  set_sensitive {
    name  = "database.password"
    value = random_password.postgresql_password.result
  }

}