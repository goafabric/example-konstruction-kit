resource "helm_release" "prometheus" {
  repository = "https://prometheus-community.github.io/helm-charts"
  name       = "prometheus"
  chart      = "prometheus"
  version    = "25.19.1"
  namespace  = "monitoring"
  create_namespace = true

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
}