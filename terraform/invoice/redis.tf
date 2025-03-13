resource "helm_release" "redis" {
  count = local.cache_type == "redis" ? 1 : 0

  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  namespace  = "invoice"
  version    = "20.1.1"

  set {
    name  = "architecture"
    value = "replication"
  }
  set {
    name  = "sentinel.enabled"
    value = true
  }
  set {
    name  = "sentinel.masterSet"
    value = "master"
  }
  set {
    name  = "replica.replicaCount"
    value = "1" #@ see scaler-policy
  }
  
  set {
    name  = "sentinel.persistence.size"
    value = "2Gi"
  }
  set {
    name  = "replica.persistence.size"
    value = "2Gi"
  }
  set {
    name  = "sentinel.readinessProbe.initialDelaySeconds"
    value = "5"
  }
  set {
    name  = "replica.readinessProbe.initialDelaySeconds"
    value = "5"
  }
  set_sensitive {
    name  = "auth.password"
    value = random_password.cache_password.result
  }
  set {
    name  = "networkPolicy.enabled"
    value = false
  }
  set {
    name  = "commonLabels.app"
    value = "redis"
  }

}

resource "terraform_data" "remove_redis_pvc" {
  count = local.cache_type == "redis" ? 1 : 0

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=redis -n invoice"
  }
}