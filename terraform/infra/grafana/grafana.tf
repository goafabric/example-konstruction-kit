resource "helm_release" "grafana" {
  repository = "https://grafana.github.io/helm-charts"
  name       = "grafana"
  chart      = "grafana"
  version    = "7.3.8"
  namespace  = "monitoring"
  create_namespace = true

  values = [file("values.yaml")]

  set {
    name  = "ingress.hosts[0]"
    value = var.hostname
  }
  set {
    name  = "ingress.tls[0].hosts[0]"
    value = var.hostname
  }
  set {
    name = "adminUser"
    value = "admin"
  }
  set {
    name = "adminPassword"
    value = "admin"
  }
}

resource "kubernetes_manifest" "grafana-gateway" {
  manifest   = yamldecode(<<-EOF
  kind: ApisixRoute
  apiVersion: apisix.apache.org/v2
  metadata:
    name: grafana
    namespace: monitoring
  spec:
    http:
      - name: grafana
        match:
          hosts:
            - ${var.hostname}
          paths:
            - /grafana
            - /grafana/*
        websocket: true
        backends:
          - serviceName: grafana
            servicePort: 80
        plugins:
          - name: redirect
            enable: true
            config:
              http_to_https: true
          - name: proxy-rewrite
            enable: true
            config:
              regex_uri:
                - /grafana/(.*)
                - /$1
  EOF
  )
}
