resource "helm_release" "kong" {
  name             = "kong"
  repository       = "https://charts.konghq.com"
  chart            = "kong"
  version          = "2.42.0"
  namespace        = "kong"
  timeout          = "60"
  create_namespace = false

  set {
   name  = "proxy.type"
   value = local.ingress_service_type
  }
  set {
    name  = "proxy.tls.nodePort"
    value = "32443"
  }
  set {
    name  = "proxy.tls.nodePort"
    value = "32443"
  }
  set {
    name  = "postgresql.enabled"
    value = true
  }
  set {
    name  = "ingressController.env.log_level"
    value = "info"
  }
  set {
    name  = "env.log_level"
    value = "info"
  }

  # oidc
  set {
    name  = "image.repository"
    value = "goafabric/kong-oidc"
  }
  set {
    name  = "image.tag"
    value = "3.8.0"
  }
  set {
    name  = "image.pullPolicy"
    value = "Always"
  }

  set {
    name  = "env.nginx_proxy_proxy_buffer_size"
    value = "128k"
  }
  set {
    name  = "env.nginx_proxy_proxy_busy_buffers_size"
    value = "128k"
  }
  set {
    name  = "env.nginx_proxy_proxy_buffers"
    value = "32 128k"
  }

}

