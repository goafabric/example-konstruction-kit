resource "helm_release" "loki" {
  repository = "https://grafana.github.io/helm-charts"
  name       = "loki"
  chart      = "loki" #loki-stack is used to also get promtail
  version    = "6.51.0"
  namespace  = "grafana"
  timeout    = "120"
  create_namespace = false

  set {
    name  = "deploymentMode"
    value = "SingleBinary"
  }

  set {
    name  = "singleBinary.replicas"
    value = "1"
  }

  set {
    name  = "loki.commonConfig.replication_factor"
    value = "1"
  }

  set {
    name  = "loki.auth_enabled"
    value = "false"
  }


  set {
    name  = "lokiCanary.enabled"
    value = "false"
  }

  set {
    name  = "chunksCache.enabled"
    value = "false"
  }

  set {
    name  = "test.enabled"
    value = "false"
  }

  set {
    name  = "loki.storage.type"
    value = "filesystem"
  }

  set {
    name  = "loki.useTestSchema"
    value = true
  }

  # tedious manual setting of 0 replicas
  set {
    name  = "backend.replicas"
    value = "0"
  }

  set {
    name  = "read.replicas"
    value = "0"
  }

  set {
    name  = "write.replicas"
    value = "0"
  }

  set {
    name  = "ingester.replicas"
    value = "0"
  }

  set {
    name  = "querier.replicas"
    value = "0"
  }

  set {
    name  = "queryFrontend.replicas"
    value = "0"
  }


}