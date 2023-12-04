variable "hostname" {
  default = "kubernetes"
}

variable "ingress_service_type" {
  default = "LoadBalancer"
}

variable "infra_repository" {
  default = "../../../../helm/templates/infra" #"https://goafabric.github.io/example-konstruction-kit/helm/charts/example/infra"
}