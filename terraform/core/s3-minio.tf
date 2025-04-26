resource "helm_release" "s3-minio" {
  name       = "s3-minio"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "minio"
  namespace  = "data"
  version    = "16.0.8"
  timeout = 60

  set {
    name  = "persistence.size"
    value = "2Gi"
  }

  set {
    name  = "auth.rootUser"
    value = "minioadmin"
  }
  set_sensitive {
    name  = "auth.rootPassword"
    value = "minioadmin" #${random_password.s3_password.result}
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
  set {
    name = "commonLabels.app"
    value = "s3-minio"
  }
}