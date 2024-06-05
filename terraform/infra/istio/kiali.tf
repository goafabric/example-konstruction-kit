resource "helm_release" "kiali" {
  name       = "kiali"
  repository = "https://kiali.org/helm-charts"
  chart      = "kiali-server"
  namespace  = "istio-system"
  create_namespace = true
  version    = "1.82.0"
  wait       = true

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

  # grafana
  set {
    name  = "external_services.grafana.in_cluster_url"
    value = "http://grafana.monitoring:80"
  }
  set {
    name  = "external_services.grafana.health_check_url"
    value = "http://grafana.monitoring:80/healthz"
  }
  set {
    name  = "external_services.grafana.url"
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
    name  = "external_services.tracing.in_cluster_url"
    value = "http://tempo.monitoring:3100/"
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
  manifest   = yamldecode(<<-EOF
  kind: ApisixRoute
  apiVersion: apisix.apache.org/v2
  metadata:
    name: kiali
    namespace: istio-system
  spec:
    http:
      - name: kiali
        match:
          hosts:
            - ${var.hostname}
          paths:
            - /kiali
            - /kiali/*
        backends:
          - serviceName: kiali
            servicePort: 20001
        plugins:
          - name: redirect
            enable: true
            config:
              http_to_https: true
  EOF
  )
}

# resource "kubernetes_manifest" "kiali-gateway" {
#   manifest   = yamldecode(<<-EOF
#   apiVersion: gateway.networking.k8s.io/v1
#   kind: Gateway
#   metadata:
#     name: kiali-gateway
#     namespace: istio-system
#   spec:
#     gatewayClassName: kong
#     listeners:
#       - name: https
#         port: 443
#         protocol: HTTPS
#         hostname: kind.local
#         tls:
#           mode: Terminate
#           certificateRefs:
#             - kind: Secret
#               name: root-certificate
#   EOF
#   )
# }
#
# resource "kubernetes_manifest" "kiali-httproute" {
#   manifest   = yamldecode(<<-EOF
#   apiVersion: gateway.networking.k8s.io/v1
#   kind: HTTPRoute
#   metadata:
#     name: kiali-route
#     namespace: istio-system
#   spec:
#     parentRefs:
#       - name: kiali-gateway
#         sectionName: https
#     hostnames:
#       - kind.local
#     rules:
#       - matches:
#           - path:
#               type: PathPrefix
#               value: /kiali
#         backendRefs:
#           - name: kiali
#             port: 20001
#   EOF
#   )
# }

resource "kubernetes_manifest" "kiali-ingress" {
  manifest   = yamldecode(<<-EOF
  kind: Ingress
  apiVersion: networking.k8s.io/v1
  metadata:
    name: kiali-ingress
    namespace: istio-system
    annotations:
      cert-manager.io/cluster-issuer: my-cluster-issuer
  spec:
    ingressClassName: kong
    tls:
      - hosts:
          - ${var.hostname}
        secretName: root-certificate
    rules:
      - host: ${var.hostname}
        http:
          paths:
            - path: /kiali
              pathType: ImplementationSpecific
              backend:
                service:
                  name: kiali
                  port:
                    number: 20001
  EOF
  )
}

resource "terraform_data" "prometheus" {
  depends_on = [helm_release.kiali]
  provisioner "local-exec" {
    when = create
    command = "kubectl apply -f ./templates/prometheus.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete --ignore-not-found -f ./templates/prometheus.yaml"
  }
}
