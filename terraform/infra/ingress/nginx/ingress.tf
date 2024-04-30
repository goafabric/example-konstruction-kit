resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = "4.10.0"
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = local.ingress_service_type
  }

  set {
    name  = "controller.service.nodePorts.https"
    value = "32443"
  }

  set {
    name  = "controller.allowSnippetAnnotations"
    value = true
  }

}