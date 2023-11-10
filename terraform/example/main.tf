provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

}

variable "hostname" {}

variable "server_arch" { }

variable "helm_repository" {
  default = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring" # "../../helm/templates/example/spring"
}

resource "helm_release" "callee-service-application" {
  repository = var.helm_repository
  name       = "callee-service-application"
  chart      = "callee-service-application"
  version    = "1.1.1"
  namespace  = "example"
  create_namespace = true
  timeout = 30

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image.arch"
    value = "-native${var.server_arch}"
  }
  set {
    name  = "replicaCount"
    value = "1"
  }
}

resource "helm_release" "person-service-postgres" {
  repository = var.helm_repository
  name       = "person-service-postgres"
  chart      = "person-service-postgres"
  version    = "1.1.1"
  namespace  = "example"
  create_namespace = true
  timeout = 30
}

resource "helm_release" "person-service-application" {
  repository = var.helm_repository
  name       = "person-service-application"
  chart      = "person-service-application"
  version    = "1.1.1"
  namespace  = "example"
  create_namespace = true
  timeout = 30

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image.arch"
    value = "-native${var.server_arch}"
  }
}