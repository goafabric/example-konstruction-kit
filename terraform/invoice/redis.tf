resource "helm_release" "redis" {
  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  namespace  = "invoice"
  version    = "19.5.2"

  set {
    name  = "architecture"
    value = "replication"
  }
  set {
    name  = "sentinel.enabled"
    value = true
  }
  set {
    name  = "replica.replicaCount"
    value = local.replica_count
  }
  
  set {
    name  = "master.persistence.size"
    value = "2Gi"
  }
  set {
    name  = "replica.persistence.size"
    value = "2Gi"
  }
  set {
    name  = "sentinal.persistence.size"
    value = "2Gi"
  }
  set {
    name  = "master.readinessProbe.initialDelaySeconds"
    value = "5"
  }
  set {
    name  = "replica.readinessProbe.initialDelaySeconds"
    value = "5"
  }
  set {
    name  = "sentinel.readinessProbe.initialDelaySeconds"
    value = "5"
  }
  set {
    name  = "auth.password"
    value = random_password.redis_password.result
  }

  set {
    name  = "networkPolicy.enabled"
    value = false
  }

}

resource "terraform_data" "remove_redis_pvc" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=redis -n invoice"
  }
}