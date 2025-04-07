resource "helm_release" "person-service-application" {
  repository = "./chart"
  name       = "person-service-application"
  chart      = "./chart/template"
  namespace  = "example"
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

  set {
    name = "oidc.enabled"
    value = false
  }



}