resource "helm_release" "catalog-application" {
  repository = var.example_repository
  name       = "catalog-application"
  chart      = "catalog-application"
  version    = "1.1.1"
  namespace  = "core"
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
    name  = "security.authentication.enabled"
    value = "false"
  }
  set {
    name  = "replicaCount"
    value = "1"
  }
}

resource "helm_release" "catalog-batch" {
  repository = var.example_repository
  name       = "catalog-batch"
  chart      = "catalog-batch"
  version    = "1.1.1"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "image.arch"
    value = "-native${var.server_arch}"
  }
}