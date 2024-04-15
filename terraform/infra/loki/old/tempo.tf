resource "helm_release" "tempo" {
  name       = "tempo"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "tempo-distributed"
  version    = "1.8.5"
  namespace  = "monitoring"
  timeout    = "600"

  set {
    name  = "global.image.registry"
    value = "cgm-hub.docker.artifactory.cgm.ag"
  }

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
    value = "s3"
  }

  set {
    name  = "storage.trace.s3.bucket"
    value = "tempo"
  }

  set {
    name  = "storage.trace.s3.endpoint"
    value = "s3-minio.core:9000"
  }

  set {
    name  = "storage.trace.s3.access_key"
    value = "admin"
  }

  set {
    name  = "storage.trace.s3.secret_key"
    value = "admin"
  }

  set {
    name  = "storage.trace.s3.insecure"
    value = true
  }
}