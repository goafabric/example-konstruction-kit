resource "helm_release" "apisix" {
  name       = "apisix"
  repository = "https://apache.github.io/apisix-helm-chart"
  chart      = "apisix"
  version    = "2.11.0"
  namespace  = "ingress-apisix"
  timeout    = "120"
  create_namespace = false
  depends_on = [helm_release.etcd]


  set {
    name  = "service.type"
    value = local.ingress_service_type
  }

  set {
    name  = "autoscaling.enabled"
    value = "true"
  }

  set {
    name  = "autoscaling.maxReplicas"
    value = "3"
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
    value = ["opentelemetry", "openid-connect", "redirect", "proxy-rewrite", "basic-auth", "serverless-pre-function", "serverless-post-function"]
  }

  set {
    name  = "apisix.customPlugins.enabled"
    value = "false"
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
    lua_shared_dict tenant_cache 10m;
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
    name  = "ingress-controller.enabled"
    value = "true"
  }

  set {
    name  = "apisix.nginx.logs.errorLogLevel"
    value = "warn"
  }

  # etcd
  set {
    name  = "etcd.enabled"
    value = false
  }

  set {
    name  = "externalEtcd.host[0]"
    value = "http://etcd.ingress-apisix:2379"
  }

  set {
    name = "externalEtcd.user"
    value = ""
  }

  # super secret flag required for apisix helm chart 2.12+, https://github.com/apache/apisix-ingress-controller/issues/2508
  set {
    name = "ingress-controller.gatewayProxy.createDefault"
    value = true
  }

}

resource "helm_release" "apisix-tls" {
  depends_on = [terraform_data.re-init_ingress_controller]
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
          ingressClassName: apisix
          hosts:
            - ${var.hostname}
          secret:
            name: root-certificate
            namespace: cert-manager
    EOF
  ]
}

#reload ingress-controller to avoid browser "ERR_SSL_PROTOCOL_ERROR" / failed to find SNI,
#could be due to connection errors to etcd or ingress-apisix -> apisix(-admin) in istio ambient mode, because apisix uses an init container with nc which will fail / always return true in istio ambient
resource "terraform_data" "re-init_ingress_controller" {
  depends_on = [helm_release.apisix]
  provisioner "local-exec" {
    when    = create
    command = "kubectl delete pod -l app.kubernetes.io/name=ingress-controller -n ingress-apisix"
  }
}

