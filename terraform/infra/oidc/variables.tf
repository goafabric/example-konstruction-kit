variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 200
}

variable "infra_repository" {
  default = "../../../helm/infra" #"https://goafabric.github.io/example-konstruction-kit/helm/charts/example/infra"
}