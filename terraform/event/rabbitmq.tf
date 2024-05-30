resource "helm_release" "rabbitmq" {
  count = local.dispatcher_profile == "rabbitmq" ? 1 : 0

  name       = "rabbitmq"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"
  version    = "13.0.0"
  namespace  = "event"
  create_namespace = "true"

  set {
    name = "replicaCount"
    value = local.messageBroker_replica_count
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
    value = random_password.messageBroker_password.result
  }
  set {
    name  = "networkPolicy.enabled"
    value = false
  }

}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_rabbitmq_pvc" {
  count = local.dispatcher_profile == "rabbitmq" ? 1 : 0

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=rabbitmq -n event"
  }
}
