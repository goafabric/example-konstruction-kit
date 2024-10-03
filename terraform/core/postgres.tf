resource "helm_release" "core-postgres-postgresql-ha-pgpool" {
  count = local.postgres_ha == false ? 1 : 0

  name       = "core-postgres-postgresql-ha-pgpool"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.5.36"
  namespace  = "core"
  timeout = var.helm_timeout

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
    value = "core"
  }

  set {
    name  = "auth.enablePostgresUser"
    value = false
  }

  set {
    name  = "primary.readinessProbe.initialDelaySeconds"
    value = "2"
  }
  set {
    name  = "primary.readinessProbe.periodSeconds"
    value = "2"
  }

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
    name  = "primary.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-addr"
    value = "http://vault.vault:8200"
  }
  set {
    name  = "primary.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-role"
    value = "vault-read-role"
  }
  set {
    name  = "primary.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-env-from-path"
    value = "databases/data/core-service-postgres"
  }

}


# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/name=postgresql -n core"
  }
}