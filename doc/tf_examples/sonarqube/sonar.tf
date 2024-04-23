resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "sonarqube"
  version    = "5.0.2"
  namespace  = "sonarqube"
  create_namespace = true

  set {
    name  = "service.nodePorts.http"
    value = "32300"
  }
}

