provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

}

variable "hostname" {}

variable "example_repository" {
  default = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
}

# core

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
    name  = "image-arch"
    value = "-native"
  }
  set {
    name  = "security.authentication.enabled"
    value = "false"
  }
}

resource "helm_release" "core-postgres" {
  repository = var.example_repository
  name       = "core-postgres"
  chart      = "core-postgres"
  version    = "1.1.1"
  namespace  = "core"
  create_namespace = true
}

# catalog

resource "helm_release" "catalog-application" {
  repository = var.example_repository
  name       = "catalog-application"
  chart      = "catalog-application"
  version    = "1.1.1"
  namespace  = "core"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image-arch"
    value = "-native"
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
}

# minio

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