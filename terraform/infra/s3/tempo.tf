resource "helm_release" "s3-minio" {
  name       = "s3-minio"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "minio"
  namespace  = "grafana"
  version    = "14.1.2"
  timeout = "90"
  create_namespace = "true"

  set {
    name  = "persistence.size"
    value = "2Gi"
  }

  set {
    name  = "auth.rootUser"
    value = "minioadmin"
  }
  set {
    name  = "auth.rootPassword"
    value = "minioadmin"
  }
  set {
    name  = "readinessProbe.initialDelaySeconds"
    value = "2"
  }
  set {
    name  = "readinessProbe.initialDelaySeconds"
    value = "2"
  }
  set {
    name  = "extraEnvVars[0].name"
    value = "TZ"
  }
  set {
    name  = "extraEnvVars[0].value"
    value = "Europe/Berlin"
  }
}

resource "aws_s3_bucket" "tempo-bucket" {
  depends_on = [helm_release.s3-minio]
  bucket = "tempo"
}
