provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

#management.otlp.tracing.endpoint: "http://tempo-distributor.monitoring:4318/v1/traces"


provider "aws" {
  access_key                  = "minioadmin"
  secret_key                  = "minioadmin"
  region                      = "eu-central-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3             = "http://s3-minio.grafana:9000"
  }
}