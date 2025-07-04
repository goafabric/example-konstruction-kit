resource "helm_release" "core-provisioning" {
  repository = var.helm_repository
  name       = "core-provisioning"
  chart      = "${var.helm_repository}/core/core/provisioning"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout

  values = [
    file("../../helm/values.yaml")
  ]

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }


  # secrets
  set {
    name  = "messageBroker.password"
    value = "supersecret"
  }

  set_sensitive {
    name  = "database.password"
    value = data.kubernetes_secret.postgresql_secret.data["password"]
  }

  set_sensitive {
    name  = "s3.password"
    value = data.kubernetes_secret.s3_secret.data["password"]
  }
  
}

