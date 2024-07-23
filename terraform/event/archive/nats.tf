resource "helm_release" "nats" {
  count = local.dispatcher_profile == "nats" ? 1 : 0

  name       = "nats"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nats"
  version    = "8.2.9"
  namespace  = "event"
  create_namespace = false

  set {
    name = "replicaCount"
    value = "2" #local.messageBroker_replica_count
  }
  set {
    name = "jetstream.enabled"
    value = true
  }
  set {
    name  = "persistence.enabled"
    value = true
  }
  set {
    name  = "resourceType"
    value = "statefulset"
  }
  set {
    name  = "persistence.size"
    value = "2Gi"
  }

  set {
    name = "auth.enabled"
    value = false
  }
  set {
    name = "auth.user"
    value = "nats_client"
  }
  set {
    name = "auth.password"
    value = random_password.messageBroker_password.result
  }

}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_nats_pvc" {
  count = local.dispatcher_profile == "nats" ? 1 : 0

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=nats -n event"
  }
}
