resource "helm_release" "person-service-postgres" {
  name       = "person-service-postgres-postgresql-ha-pgpool"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.5.36"
  namespace  = "example"
  timeout = "50"

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
    value = "databases/data/person-service-postgres"
  }
  
}


# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=person-service-postgres -n example"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=person-service-postgres-postgresql-ha-pgpool -n example"
  }

}

# resource "kubernetes_service_account" "vault_read_account" {
#   metadata {
#     name      = "vault-read-account"
#     namespace = "example"
#   }
# }