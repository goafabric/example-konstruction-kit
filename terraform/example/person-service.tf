resource "helm_release" "person-service-postgres" {
  repository = var.helm_repository
  name       = "person-service-postgres"
  chart      = "${var.helm_repository}/person-service/postgres"
  version    = "1.1.2"
  namespace  = "example"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
}

resource "helm_release" "person-service-application" {
  repository = var.helm_repository
  name       = "person-service-application"
  chart      = "${var.helm_repository}/person-service/application"
  version    = "1.1.2"
  namespace  = "example"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image.arch"
    value = "-native${var.server_arch}"
  }
  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
}