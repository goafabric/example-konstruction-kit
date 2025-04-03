resource "helm_release" "kafka" {
  name       = "kafka"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  version    = "31.0.0"
  namespace  = "data"
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
  set_sensitive {
    name = "sasl.client.passwords[0]"
    value = "supersecret" #random_password.messageBroker_password.result
  }
  set {
    name  = "networkPolicy.enabled"
    value = false
  }
  set {
    name  = "metrics.jmx.enabled"
    value = true
  }
  set {
    name  = "commonLabels.app"
    value = "kafka"
  }
}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_kafka_pvc" {
  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=kafka -n event"
  }
}
