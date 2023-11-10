resource "helm_release" "core-postgres" {
  repository = var.example_repository
  name       = "core-postgres"
  chart      = "core-postgres"
  version    = "1.1.1"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout
}

resource "helm_release" "core-application" {
  repository = var.example_repository
  name       = "core-application"
  chart      = "core-application"
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
}

resource "helm_release" "s3-minio" {
  repository = var.example_repository
  name       = "s3-minio"
  chart      = "s3-minio"
  version    = "1.1.1"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}