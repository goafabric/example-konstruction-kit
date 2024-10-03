resource "helm_release" "redis" {
  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  namespace  = "invoice"
  version    = "20.1.1"
  timeout = 40

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
    value = "1"
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
   value = "secret" #random_password.redis_password.result
 }
  set {
    name  = "networkPolicy.enabled"
    value = false
  }


  # vault service account
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
    name  = "master.automountServiceAccountToken"
    value = true
  }
  set {
    name  = "master.serviceAccount.create"
    value = false
  }
  set {
    name  = "master.serviceAccount.name"
    value = "vault-read-account"
  }

  set {
    name  = "replica.automountServiceAccountToken"
    value = true
  }
  set {
    name  = "replica.serviceAccount.create"
    value = false
  }
  set {
    name  = "replica.serviceAccount.name"
    value = "vault-read-account"
  }

  # vault injection
  set {
    name  = "master.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-addr"
    value = "http://vault.vault:8200"
  }
  set {
    name  = "master.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-role"
    value = "vault-read-role"
  }
  set {
    name  = "master.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-env-from-path"
    value = "databases/data/invoice-redis"
  }

  set {
    name  = "replica.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-addr"
    value = "http://vault.vault:8200"
  }
  set {
    name  = "replica.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-role"
    value = "vault-read-role"
  }
  set {
    name  = "replica.podAnnotations.vault\\.security\\.banzaicloud\\.io/vault-env-from-path"
    value = "databases/data/invoice-redis"
  }
}

resource "terraform_data" "remove_redis_pvc" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=redis -n invoice"
  }
}