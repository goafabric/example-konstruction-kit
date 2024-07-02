resource "helm_release" "nats" {
  count = local.dispatcher_profile == "nats" ? 1 : 0

  name       = "nats"
  repository = "https://nats-io.github.io/k8s/helm/charts/"
  chart      = "nats"
  version    = "1.2.0"
  namespace  = "event"
  create_namespace = false


  set {
    name = "config.cluster.enabled"
    value = true
  }
  set {
    name = "config.cluster.replicas"
    value = "3"
  }
  set {
    name = "config.jetstream.enabled"
    value = true
  }
  set {
    name = "config.jetstream.fileStore.pvc.size"
    value = "2Gi"
  }
}

#manually remove the pvc to avoid password problems
resource "terraform_data" "remove_nats_pvc" {
  count = local.dispatcher_profile == "nats" ? 1 : 0

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=nats -n event"
  }
}
