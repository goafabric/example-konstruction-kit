resource "helm_release" "core-application" {
  repository = var.helm_repository
  name       = "core-application"
  chart      = "${var.helm_repository}/core/application"
  version    = "1.1.2"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "image.arch"
    value = "-native${local.server_arch}"
  }
  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "security.authentication.enabled"
    value = local.authentication_enabled
  }
  set {
    name  = "replicaCount"
    value = "1"
  }
  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
  set {
    name  = "s3.password"
    value = random_password.s3_password.result
  }
}

resource "helm_release" "core-postgres" {
  repository = var.helm_repository
  name       = "core-postgres"
  chart      = "${var.helm_repository}/core/postgres"
  version    = "1.1.2"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
}
