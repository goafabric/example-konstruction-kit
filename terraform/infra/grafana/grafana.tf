resource "helm_release" "grafana" {
  repository = "https://grafana.github.io/helm-charts"
  name       = "grafana"
  chart      = "grafana"
  version    = "7.3.8"
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
  set {
    name = "adminUser"
    value = "admin"
  }
  set {
    name = "adminPassword"
    value = "admin"
  }
}