resource "helm_release" "rabbitmq" {
  count = local.message_broker_ha == "false" ? 1 : 0

  repository = var.helm_repository
  name       = "rabbitmq"
  chart      = "${var.helm_repository}/rabbitmq/application"
#  version    = "3.12.1"
  namespace  = "message-broker"
  create_namespace = true
  timeout = var.helm_timeout

 set {
    name  = "messageBroker.password"
    value = random_password.database_password.result
  }
}

resource "helm_release" "rabbitmq-ha" {
  count = local.message_broker_ha == "true" ? 1 : 0

  name       = "rabbitmq"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"
  version    = "13.0.0"
  namespace  = "message-broker"
  create_namespace = "true"

  set {
    name = "replicaCount"
    value = local.replica_count
  }
  set {
    name  = "persistence.size"
    value = "2Gi"
  }

  set {
    name  = "auth.username"
    value = "admin" 
  }

  set {
    name  = "auth.password"
    value = random_password.database_password.result
  }
}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {
  count = local.message_broker_ha == "true" ? 1 : 0

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=rabbitmq -n message-broker"
  }
}
