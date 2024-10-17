resource "helm_release" "grafana" {
  repository = "https://grafana.github.io/helm-charts"
  name       = "grafana"
  chart      = "grafana"
  version    = "8.5.5"
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

resource "kubernetes_manifest" "grafana-gateway" {
  manifest   = yamldecode(<<-EOF
  kind: ApisixRoute
  apiVersion: apisix.apache.org/v2
  metadata:
    name: grafana
    namespace: grafana
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


resource "kubernetes_manifest" "grafana-ingress" {
  manifest   = yamldecode(<<-EOF
  kind: Ingress
  apiVersion: networking.k8s.io/v1
  metadata:
    name: grafana-ingress
    namespace: grafana
    annotations:
      cert-manager.io/cluster-issuer: my-cluster-issuer
#      konghq.com/strip-path: 'true'
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
            - path: /grafana
              pathType: ImplementationSpecific
              backend:
                service:
                  name: grafana
                  port:
                    number: 80
  EOF
  )
}