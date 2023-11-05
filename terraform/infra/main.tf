provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

}

variable "hostname" {}

variable "infra_repository" {
  default = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/infra"
}

resource "helm_release" "welcome-board" {
  repository = var.infra_repository
  name       = "welcome-board"
  chart      = "welcome-board"
  version    = "1.1.1"
  namespace  = "default"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}
