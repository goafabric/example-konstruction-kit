resource "helm_release" "kafka" {
  name       = "kafka"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "kafka"
  version    = "32.3.2"
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
    name  = "overrideConfiguration"
    value = <<-EOT
      offsets.topic.replication.factor: ${local.kafka_replica_count}
      transaction.state.log.replication.factor: ${local.kafka_replica_count}
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
    value = kubernetes_secret.kafka_secret.data["password"]
  }
  set {
    name  = "networkPolicy.enabled"
    value = false
  }
  set {
    name  = "metrics.jmx.enabled"
    value = false
  }
  set {
    name  = "commonLabels.app"
    value = "kafka"
  }

  set {
    name  = "controller.readinessProbe.initialDelaySeconds"
    value = "5"
  }
}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_kafka_pvc" {
  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=kafka -n data"
  }
}
