resource "helm_release" "kafka" {
  name       = "kafka"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  version    = "30.1.0"
  namespace  = "event"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name = "controller.replicaCount"
    value = local.kafka_replica_count
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
    value = random_password.kafka_password.result
  }
  set {
    name  = "automountServiceAccountToken"
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

  set {
    name  = "controller.automountServiceAccountToken"
    value = true
  }
  set {
    name  = "controller.serviceAccount.create"
    value = false
  }
  set {
    name  = "controller.serviceAccount.name"
    value = "vault-read-account"
  }

  set {
    name  = "broker.automountServiceAccountToken"
    value = true
  }
  set {
    name  = "broker.serviceAccount.create"
    value = false
  }
  set {
    name  = "broker.serviceAccount.name"
    value = "vault-read-account"
  }

  # vault injection
  set {
    name  = "controller.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-addr"
    value = "http://vault.vault:8200"
  }
  set {
    name  = "controller.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-role"
    value = "vault-read-role"
  }
  set {
    name  = "controller.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-env-from-path"
    value = "databases/data/event-kafka"
  }

  set {
    name  = "broker.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-addr"
    value = "http://vault.vault:8200"
  }
  set {
    name  = "broker.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-role"
    value = "vault-read-role"
  }
  set {
    name  = "broker.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-env-from-path"
    value = "databases/data/event-kafka"
  }
}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_kafka_pvc" {
  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=kafka -n event"
  }
}
