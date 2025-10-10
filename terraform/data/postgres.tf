resource "helm_release" "postgresql" {

  name       = "postgresql"
  repository = "oci://registry-1.docker.io/cloudpirates"
  chart      = "postgres"
  version    = "0.8.0"
  namespace  = "data"
  
  # set {
  #   name  = "extraEnv[0].name"
  #   value = "TZ"
  # }
  #
  # set {
  #   name  = "extraEnv[0].value"
  #   value = "Europe/Berlin"
  # }

  set {
    name  = "initdb.scripts.00_pg_statements\\.sql"
    value = "CREATE EXTENSION pg_stat_statements;"
  }
  
  set {
    name  = "auth.database"
    value = "main"
  }
  set_sensitive {
    name  = "auth.username"
    value = kubernetes_secret.postgresql_secret["core"].data["username"]
  }
  set_sensitive {
    name  = "auth.password"
    value = kubernetes_secret.postgresql_secret["core"].data["password"]
  }

  # set {
  #   name  = "readinessProbe.initialDelaySeconds"
  #   value = "2"
  # }
  #
  # set {
  #   name  = "livenessProbe.initialDelaySeconds"
  #   value = "2"
  # }

}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc data-postgresql-0 -n data"
  }
}