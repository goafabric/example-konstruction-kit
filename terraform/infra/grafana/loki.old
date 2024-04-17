resource "helm_release" "loki" {
  repository = "https://grafana.github.io/helm-charts"
  name       = "loki"
  chart      = "loki-stack"
  version    = "v2.10.2"
  namespace  = "monitoring"
  create_namespace = true

  set {
    name  = "grafana.enabled"
    value = "false"
  }
  # no prometheus is of course invalid for production
  set {
    name  = "prometheus.enabled"
    value = "false"
  }
  set {
    name  = "prometheus.alertmanager.persistentVolume.enabled"
    value = "false"
  }
  set {
    name  = "prometheus.server.persistentVolume.enabled"
    value = "false"
  }
}