variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 120
}

variable "helm_repository" {
  default = "https://github.com/goafabric/example-konstruction-kit"
}

locals {
  oidc_enabled = strcontains(var.hostname, ".de")
  kafka_replica_count = "1" #for production this should be 3
}
