resource "helm_release" "kong" {
  name             = "kong"
  repository       = "https://charts.konghq.com"
  chart            = "kong"
  version          = "2.38.0"
  namespace        = "kong"
  timeout          = "120"
  create_namespace = true

  set {
   name  = "proxy.type"
   value = local.ingress_service_type
  }

  set {
    name  = "proxy.tls.nodePort"
    value = "32443"
  }

#   set {
#     name  = "postgresql.enabled"
#     value = true
#   }
}

