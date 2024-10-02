resource "helm_release" "s3-minio" {
  name       = "s3-minio"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "minio"
  namespace  = "core"
  version    = "14.1.2"
  timeout = 60

  set {
    name  = "persistence.size"
    value = "2Gi"
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


  ### vault stuff
  
  # vault service account
  set {
    name  = "primary.automountServiceAccountToken"
    value = true
  }
  set {
    name  = "serviceAccount.create"
    value = false
  }
  set {
    name  = "serviceAccount.name"
    value = "vault-read-account"
  }

  # vault injection
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
    value = "databases/data/core-minio"
  }

  # set auth to none, as it cannot be disabled, will be overwritten by pod injection

  set {
    name  = "auth.rootUser"
    value = "none"
  }
  set_sensitive {
    name  = "auth.rootPassword"
    value = "none"
  }

}