resource "helm_release" "tempo" {
  name       = "tempo"
  repository = "https://grafana.github.io/helm-charts"
#  chart      = "tempo-distributed"
#  version    = "1.8.5"
  chart      = "tempo"
  version    = "1.24.4"
  namespace  = "grafana"
  timeout    = "120"
  create_namespace = false
  
  set {
    name  = "traces.otlp.http.enabled"
    value = true
  }

  set {
    name  = "traces.otlp.grpc.enabled"
    value = true
  }

  set {
    name  = "storage.trace.backend"
    value = "local" #"s3"
  }

  # set {
  #   name  = "storage.trace.s3.bucket"
  #   value = "tempo"
  # }
  #
  # set {
  #   name  = "storage.trace.s3.endpoint"
  #   value = "s3-minio:9000"
  # }
  #
  # set {
  #   name  = "storage.trace.s3.access_key"
  #   value = "minioadmin"
  # }
  #
  # set {
  #   name  = "storage.trace.s3.secret_key"
  #   value = "minioadmin"
  # }
  #
  # set {
  #   name  = "storage.trace.s3.insecure"
  #   value = true
  # }
}
