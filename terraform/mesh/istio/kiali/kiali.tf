resource "helm_release" "kiali" {
  name       = "kiali"
  repository = "https://kiali.org/helm-charts"
  chart      = "kiali-server"
  namespace  = "istio-system"
  create_namespace = false
  version    = "1.69.0"
  wait       = true

  set {
    name  = "auth.strategy"
    value = "anonymous"
  }
  set {
    name  = "external_services.custom_dashboards.enabled"
    value = "true"
  }
  set {
    name  = "external_services.tracing.in_cluster_url"
    value = "http://tracing.monitoring:16685/jaeger"
  }
  set {
    name  = "external_services.tracing.use_grpc"
    value = "true"
  }

  set {
    name  = "server.web_root"
    value = "/kiali"
  }
}


