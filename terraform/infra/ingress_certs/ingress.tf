resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = "4.7.0"
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = var.hostname == "kind" ? "NodePort" : "LoadBalancer"
  }

  set {
    name  = "controller.service.nodePorts.https"
    value = "32443"
  }

}