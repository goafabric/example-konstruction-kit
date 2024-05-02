resource "helm_release" "core-application" {
  repository = var.helm_repository
  name       = "core-application"
  chart      = "${var.helm_repository}/core/application"
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
    name  = "replicaCount"
    value = "1"
  }
  set {
    name  = "database.password"
    value = random_password.core_database_password.result
  }
  set {
    name  = "s3.password"
    value = random_password.s3_password.result
  }
  set {
    name = "authentication.enabled"
    value = local.authentication_enabled
  }
}