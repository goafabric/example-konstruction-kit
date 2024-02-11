resource "helm_release" "catalog-batch" {
  repository = var.helm_repository
  name       = "catalog-batch"
  chart      = "${var.helm_repository}/03_catalog/01_batch"
  version    = "1.1.2"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "image.arch"
    value = "-native${local.server_arch}"
  }
  set {
    name  = "database.password"
    value = random_password.database_password.result
  }

}

resource "helm_release" "catalog-application" {
  repository = var.helm_repository
  name       = "catalog-application"
  chart      = "${var.helm_repository}/03_catalog/02_application"
  version    = "1.1.2"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image.arch"
    value = "-native${local.server_arch}"
  }
  set {
    name  = "security.authentication.enabled"
    value = "false"
  }
  set {
    name  = "replicaCount"
    value = "1"
  }
  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
}