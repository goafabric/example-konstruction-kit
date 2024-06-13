resource "helm_release" "loki" {
  repository = "https://grafana.github.io/helm-charts"
  name       = "loki"
  chart      = "loki-stack" #loki-stack is used to also get promtail
  version    = "v2.10.2"
  namespace  = "grafana"
  create_namespace = false

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