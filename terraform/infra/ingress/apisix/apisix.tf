resource "helm_release" "apisix" {
  name       = "apisix"
  repository = "https://apache.github.io/apisix-helm-chart"
  chart      = "apisix"
  version    = "2.8.0"
  namespace  = "ingress-apisix"
  timeout    = "300"
  create_namespace = false

  set {
    name  = "service.type"
    value = local.ingress_service_type
  }

  set {
    name  = "apisix.ssl.enabled"
    value = "true"
  }

  set {
    name  = "service.tls.nodePort"
    value = "32443"
  }

  set {
    name  = "apisix.ssl.containerPort"
    value = "443"
  }

  set {
    name  = "apisix.pluginAttrs.redirect.https_port"
    value = "443"
  }

  set_list {
    name  = "apisix.plugins"
    value = ["opentelemetry", "openid-connect", "redirect", "proxy-rewrite", "basic-auth", "serverless-post-function"]
  }


  set {
    name  = "apisix.pluginAttrs.opentelemetry.resource.service.name"
    value = "APISIX"
  }

  set {
    name  = "apisix.pluginAttrs.opentelemetry.collector.address"
    value = "tempo-distributor.grafana:4318"
  }

  set {
    name  = "apisix.nginx.configurationSnippet.httpStart"
    value = <<-EOF
    proxy_buffer_size 128k;
    proxy_buffers 32 128k;
    proxy_busy_buffers_size 128k;
    EOF
  }

  set {
    name  = "apisix.nginx.configurationSnippet.httpSrv"
    value = <<-EOF
    proxy_buffer_size 128k;
    proxy_buffers 32 128k;
    proxy_busy_buffers_size 128k;
    EOF
  }

  set {
    name  = "podSecurityContext.sysctls[0].name"
    value = "net.ipv4.ip_unprivileged_port_start"
  }

  set {
    name  = "podSecurityContext.sysctls[0].value"
    value = "0"
    type  = "string"
  }

  set {
    name  = "etcd.replicaCount"
    value = "2"
  }

  set {
    name  = "ingress-controller.enabled"
    value = "true"
  }
}


resource "helm_release" "apisix-tls" {
  depends_on = [helm_release.apisix]
  name       = "apisix-tls"
  repository = "https://wiremind.github.io/wiremind-helm-charts/"
  chart      = "raw"
  version    = "0.1.0"
  values = [
    <<-EOF
    resources:
      - apiVersion: apisix.apache.org/v2
        kind: ApisixTls
        metadata:
          name: apisix-tls
          namespace: ingress-apisix
        spec:
          hosts:
            - ${var.hostname}
          secret:
            name: root-certificate
            namespace: cert-manager
    EOF
  ]
}

