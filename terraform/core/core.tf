resource "helm_release" "core-postgres" {
  repository = var.example_repository
  name       = "core-postgres"
  chart      = "core-postgres"
  version    = "1.1.1"
  namespace  = "core"
  create_namespace = true
}

resource "helm_release" "core-application" {
  repository = var.example_repository
  name       = "core-application"
  chart      = "core-application"
  version    = "1.1.1"
  namespace  = "core"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image.arch"
    value = "-native${var.architecture}"
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

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}