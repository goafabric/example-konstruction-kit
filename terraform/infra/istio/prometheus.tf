resource "helm_release" "prometheus" {
  repository = "https://prometheus-community.github.io/helm-charts"
  name       = "prometheus"
  chart      = "prometheus"
  version    = "25.21.0"
  namespace  = "istio-system"
  create_namespace = false

  set {
    name  = "alertmanager.enabled"
    value = false
  }
  set {
    name  = "kube-state-metrics.enabled"
    value = false
  }
  set {
    name = "prometheus-node-exporter.enabled"
    value = false
  }
  set {
    name = "prometheus-pushgateway.enabled"
    value = false
  }
  set {
    name = "server.global.scrape_interval"
    value = "15s"
  }
  set {
    name = "server.global.evaluation_interval"
    value = "1m"
  }
#   set {
#     name = "server.resources.limits.memory"
#     value = "512Mi"
#   }
}