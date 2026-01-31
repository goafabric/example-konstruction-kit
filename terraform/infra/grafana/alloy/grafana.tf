resource "helm_release" "alloy" {
  repository = "https://grafana.github.io/helm-charts"
  name       = "alloy"
  chart      = "alloy"
  version    = "1.5.3"
  namespace  = "grafana"
  create_namespace = true

  values = [file("values.yaml")]

  
}
