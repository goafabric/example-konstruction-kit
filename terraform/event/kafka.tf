resource "helm_release" "kafka" {
  count = local.message_broker_ha == "false" ? 1 : 0

  repository = var.helm_repository
  name       = "kafka"
  chart      = "${var.helm_repository}/kafka/application"
  namespace  = "event"
  create_namespace = true
  timeout = var.helm_timeout

#  set {
#     name  = "messageBroker.password"
#     value = random_password.database_password.result
#   }
}


resource "helm_release" "kafka-ha" {
  count = local.message_broker_ha == "true" ? 1 : 0

  name       = "kafka"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  version    = "29.1.1"
  namespace  = "event"
  create_namespace = "true"

  set {
    name = "controller.replicaCount"
    value = local.broker_replica_count
  }
  set {
    name  = "extraConfig"
    value = <<-EOT
      offsets.topic.replication.factor=${local.broker_replica_count}
      transaction.state.log.replication.factor=${local.broker_replica_count}
    EOT
  }
  set {
    name = "controller.heapOpts"
    value = "-Xmx256m"
  }

  set {
    name = "listeners.client.protocol"
    value = "PLAINTEXT"
  }

  set {
    name  = "persistence.size"
    value = "2Gi"
  }
}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {
  count = local.message_broker_ha == "true" ? 1 : 0

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=kafka -n event"
  }
}
