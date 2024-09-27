resource "helm_release" "s3-minio" {
  name       = "s3-minio"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "minio"
  namespace  = "core"
  version    = "14.1.2"

  set {
    name  = "persistence.size"
    value = "2Gi"
  }

  set {
    name  = "extraVolumeMounts[0].name"
    value = "kube-api-access"
  }

  set {
    name  = "extraVolumeMounts[0].mountPath"
    value = "/var/run/secrets/kubernetes.io/serviceaccount"
  }

  set {
    name  = "extraVolumeMounts[0].readOnly"
    value = "true"
  }

  set {
    name  = "extraVolumes[0].name"
    value = "kube-api-access"
  }

  set {
    name  = "extraVolumes[0].projected.sources[0].serviceAccountToken.path"
    value = "token"
  }

  set {
    name  = "extraVolumes[0].projected.sources[0].serviceAccountToken.expirationSeconds"
    value = "3600"
  }


  set {
    name  = "podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-addr"
    value = "http://vault.vault:8200"
  }
  set {
    name  = "podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-role"
    value = "vault-read-role"
  }
  set {
    name  = "podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-env-from-path"
    value = "databases/data/example-service-postgres"
  }
  set {
    name  = "serviceAccount.create"
    value = false
  }
  set {
    name  = "serviceAccount.name"
    value = "vault-read-account"
  }


  #   set {
#     name  = "auth.rootUser"
#     value = "minioadmin"
#   }
#   set_sensitive {
#     name  = "auth.rootPassword"
#     value = "minioadmin" #${random_password.s3_password.result}
#   }
  
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