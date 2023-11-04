provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

}

variable "hostname" {
  default = "kubernetes"
}

resource "helm_release" "callee-service-application" {
  repository = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
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
  repository = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
  name       = "person-service-postgres"
  chart      = "person-service-postgres"
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

resource "helm_release" "person-service-application" {
  repository = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
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