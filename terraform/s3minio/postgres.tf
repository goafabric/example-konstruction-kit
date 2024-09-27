resource "helm_release" "person-service-postgres" {
  name       = "person-service-postgres-postgresql-ha-pgpool"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.5.36"
  namespace  = "example"

  set {
    name  = "persistence.size"
    value = "2Gi"
  }

  set {
    name  = "postgresql.extraEnvVars[0].name"
    value = "TZ"
  }
  set {
    name  = "postgresql.extraEnvVars[0].value"
    value = "Europe/Berlin"
  }
  set {
    name  = "postgresql.initdbScripts.00_pg_statements\\.sql"
    value = "CREATE EXTENSION pg_stat_statements;"
  }
  set {
    name  = "global.postgresql.auth.database"
    value = "person"
  }
  set {
    name  = "global.postgresql.auth.username"
    value = "none"
  }
  set {
    name  = "global.postgresql.auth.password"
    value = "none"
  }

  set {
    name  = "primary.readinessProbe.initialDelaySeconds"
    value = "2"
  }
  set {
    name  = "primary.readinessProbe.periodSeconds"
    value = "2"
  }

  ### vault stuff

  # vault service account

  set {
    name  = "serviceAccount.create"
    value = false
  }
  set {
    name  = "serviceAccount.name"
    value = "vault-read-account"
  }

  # for whatever reason the serviceaccount directory must be mounted manually for bitnami charts
  set {
    name  = "primary.extraVolumeMounts[0].name"
    value = "kube-api-access"
  }

  set {
    name  = "primary.extraVolumeMounts[0].mountPath"
    value = "/var/run/secrets/kubernetes.io/serviceaccount"
  }

  set {
    name  = "primary.extraVolumeMounts[0].readOnly"
    value = "true"
  }

  set {
    name  = "primary.extraVolumes[0].name"
    value = "kube-api-access"
  }

  set {
    name  = "primary.extraVolumes[0].projected.sources[0].serviceAccountToken.path"
    value = "token"
  }

  set {
    name  = "primary.extraVolumes[0].projected.sources[0].serviceAccountToken.expirationSeconds"
    value = "3600"
  }

  # annotations for vault injection

  set {
    name  = "primary.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-addr"
    value = "http://vault.vault:8200"
  }
  set {
    name  = "primary.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-role"
    value = "vault-read-role"
  }
  set {
    name  = "primary.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-env-from-path"
    value = "databases/data/person-service-postgres"
  }
  
}