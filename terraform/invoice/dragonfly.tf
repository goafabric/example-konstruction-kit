resource "helm_release" "dragonfly" {
  depends_on = [kubernetes_secret.cache_secret]
  count = local.cache_type == "dragonfly" ? 1 : 0

  name       = "dragonfly"
  repository = "oci://ghcr.io/dragonflydb/dragonfly/helm"
  chart      = "dragonfly"
  namespace  = "invoice"
  version    = "v1.27.2"
  timeout = var.helm_timeout

  set {
    name  = "replicaCount"
    value = "1"
  }

  set {
    name  = "commonLabels.app"
    value = "dragonfly"
  }

  set {
    name  = "passwordFromSecret.enable"
    value = true
  }
  set {
    name  = "passwordFromSecret.existingSecret.name"
    value = "cache-secret"
  }

  set {
    name  = "passwordFromSecret.existingSecret.key"
    value = "password"
  }

  set {
    name  = "extraArgs[0]"
    value = "--proactor_threads=2"
  }
}


resource "kubernetes_secret" "cache_secret" {
  metadata {
    name      = "cache-secret"
    namespace = "invoice" # Change if needed
  }

  data = {
    password = random_password.cache_password.result
  }

  type = "Opaque"
}

