resource "helm_release" "kiali" {
  name       = "kiali"
  repository = "https://kiali.org/helm-charts"
  chart      = "kiali-server"
  namespace  = "istio-system"
  create_namespace = false
  version    = "2.12.0"
  wait       = true

  depends_on = [helm_release.istio-base, helm_release.istio-cni, helm_release.istio-istiod, helm_release.ztunnel]

  set {
    name  = "auth.strategy"
    value = "anonymous"
  }
  set {
    name  = "external_services.custom_dashboards.enabled"
    value = "true"
  }
  set {
    name  = "server.web_root"
    value = "/kiali"
  }

  # prometheus
  set {
    name  = "external_services.prometheus.url"
    value = "http://prometheus-server.istio-system:80"
  }

  # grafana
  set {
    name  = "external_services.grafana.internal_url"
    value = "http://grafana.grafana:80"
  }
  set {
    name  = "external_services.grafana.health_check_url"
    value = "http://grafana.grafana:80/healthz"
  }
  set {
    name  = "external_services.grafana.external_url"
    value = "/grafana"
  }
  
  # tempo
  set {
    name  = "external_services.tracing.enabled"
    value = true
  }
  set {
    name  = "external_services.tracing.provider"
    value = "tempo"
  }
  set {
    name  = "external_services.tracing.use_grpc"
    value = false
  }

  set {
    name  = "external_services.tracing.internal_url"
    value = "http://tempo.grafana:3100/"
  }
  set {
    name  = "external_services.tracing.tempo_config.org_id"
    value = "1"
  }
  set {
    name  = "external_services.tracing.tempo_config.datasource_uid"
    value = "tempo"
  }
  set {
    name  = "deployment.logger.log_level"
    value = "info"
  }

}

resource "kubernetes_manifest" "kiali-route" {
  depends_on = [helm_release.kiali]
  manifest = yamldecode(<<-EOF
  apiVersion: gateway.networking.k8s.io/v1
  kind: HTTPRoute
  metadata:
    name: kiali
    namespace: istio-system
  spec:
    parentRefs:
      - name: apisix
        namespace: ingress-apisix
        sectionName: https
    hostnames:
      - ${var.hostname}
    rules:
      - matches:
          - path:
              type: PathPrefix
              value: /kiali
        filters:
          - type: URLRewrite
            urlRewrite:
              path:
                type: ReplacePrefixMatch
                replacePrefixMatch: /
        backendRefs:
          - name: kiali
            port: 20001
  EOF
  )
}
