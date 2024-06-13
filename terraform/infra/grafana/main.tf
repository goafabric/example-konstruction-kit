provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

#management.otlp.tracing.endpoint: "http://tempo-distributor.grafana:4318/v1/traces"
