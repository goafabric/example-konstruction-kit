variable "hostname" {
  default = "kubernetes"
}

variable "helm_timeout" {
  default = 90
}

variable "infra_repository" {
  default = "../../../../helm/templates/infra" #"https://goafabric.github.io/example-konstruction-kit/helm/charts/example/infra"
}