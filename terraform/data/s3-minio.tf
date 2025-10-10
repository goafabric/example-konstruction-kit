resource "helm_release" "s3-minio" {
  name       = "s3-minio"
  repository = "oci://registry-1.docker.io/cloudpirates"
  chart      = "minio"
  namespace  = "data"
  version    = "0.4.0"
  timeout = 60

  set {
    name  = "config.extraEnvVars[0].name"
    value = "TZ"
  }
  set {
    name  = "config.extraEnvVars[0].value"
    value = "Europe/Berlin"
  }

  set {
    name  = "persistence.size"
    value = "2Gi"
  }

  set {
    name  = "auth.rootUser"
    value = kubernetes_secret.s3_secret["core"].data["username"]
  }
  set_sensitive {
    name  = "auth.rootPassword"
    value = kubernetes_secret.s3_secret["core"].data["password"]
  }
  set {
    name  = "readinessProbe.initialDelaySeconds"
    value = "2"
  }

  set {
    name = "podLabels.app"
    value = "s3-minio"
  }

}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_s3_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc s3-minio -n data"
  }
}