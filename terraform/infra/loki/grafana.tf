resource "helm_release" "grafana" {
  repository = "https://grafana.github.io/helm-charts"
  name       = "grafana"
  chart      = "grafana"
  version    = "6.57.0"
  namespace  = "monitoring"
  create_namespace = true

  values = [file("values.yaml")]

  set {
    name  = "ingress.hosts[0]"
    value = var.hostname
  }
  set {
    name  = "ingress.tls[0].hosts[0]"
    value = var.hostname
  }
}

resource "helm_release" "loki" {
  repository = "https://grafana.github.io/helm-charts"
  name       = "loki"
  chart      = "loki-stack"
  version    = "v2.8.9"
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



