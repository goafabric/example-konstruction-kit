provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

}

variable "hostname" {}

variable "example_repository" {
  default = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
}

resource "helm_release" "core-postgres" {
  repository = var.example_repository
  name       = "core-postgres"
  chart      = "core-postgres"
  version    = "1.1.1"
  namespace  = "core"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
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
    name  = "image-arch"
    value = "-native"
  }
}
