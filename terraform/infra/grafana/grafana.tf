resource "helm_release" "grafana" {
  repository = "https://grafana.github.io/helm-charts"
  name       = "grafana"
  chart      = "grafana"
  version    = "10.0.0"
  namespace  = "grafana"
  create_namespace = false

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

resource "kubernetes_manifest" "grafana-route" {
  manifest   = yamldecode(<<-EOF
  apiVersion: gateway.networking.k8s.io/v1
  kind: HTTPRoute
  metadata:
    name: grafana
    namespace: grafana
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
              value: /grafana
        backendRefs:
          - name: grafana
            port: 80
  EOF
  )
}
