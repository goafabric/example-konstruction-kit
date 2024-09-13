resource "helm_release" "kafka" {
  name       = "kafka"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  version    = "30.1.0"
  namespace  = "event"
  create_namespace = false

  set {
    name = "controller.replicaCount"
    value = local.kafka_replica_count
  }
  set {
    name  = "persistence.size"
    value = "2Gi"
  }
  set {
    name  = "extraConfig"
    value = <<-EOT
      offsets.topic.replication.factor=${local.kafka_replica_count}
      transaction.state.log.replication.factor=${local.kafka_replica_count}
    EOT
  }
  set {
    name = "controller.heapOpts"
    value = "-Xmx256m"
  }

  set {
    name = "listeners.client.protocol"
    value = "SASL_PLAINTEXT"
  }
  set {
    name = "sasl.client.users[0]"
    value = "admin"
  }
  set {
    name = "sasl.client.passwords[0]"
    value = "supersecret" #random_password.messageBroker_password.result
  }
  set {
    name  = "networkPolicy.enabled"
    value = false
  }
}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_kafka_pvc" {
  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=kafka -n event"
  }
}
