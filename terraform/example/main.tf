provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

}

variable "hostname" {}

variable "example_repository" {
  default = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring" # "example-spring"
}

resource "helm_release" "callee-service-application" {
  repository = var.example_repository
  name       = "callee-service-application"
  chart      = "callee-service-application"
  version    = "1.1.1"
  namespace  = "example"
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
    name  = "replicaCount"
    value = "1"
  }
}

resource "helm_release" "person-service-postgres" {
  repository = var.example_repository
  name       = "person-service-postgres"
  chart      = "person-service-postgres"
  version    = "1.1.1"
  namespace  = "example"
  create_namespace = true
}

resource "helm_release" "person-service-application" {
  repository = var.example_repository
  name       = "person-service-application"
  chart      = "person-service-application"
  version    = "1.1.1"
  namespace  = "example"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image-arch"
    value = "-native"
  }
}