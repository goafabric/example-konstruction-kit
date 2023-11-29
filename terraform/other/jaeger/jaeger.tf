resource "helm_release" "jaeger" {
  repository = "https://jaegertracing.github.io/helm-charts"
  name       = "jaeger"
  chart      = "jaeger"
  version    = "0.72.1"
  namespace  = "monitoring"
  create_namespace = true

  set {
    name  = "allInOne.enabled"
    value = "true"
  }
  set {
    name  = "provisionDataStore.cassandra"
    value = "false"
  }
  set {
    name  = "storage.type"
    value = "none"
  }
  set {
    name  = "agent.enabled"
    value = "false"
  }
  set {
    name  = "collector.enabled"
    value = "false"
  }
  set {
    name  = "query.enabled"
    value = "false"
  }
  set {
    name  = "allInOne.extraEnv[0].name"
    value = "QUERY_BASE_PATH"
  }
  set {
    name  = "allInOne.extraEnv[0].value"
    value = "/jaeger"
  }
}

resource "kubernetes_manifest" "jaeger-ingress" {
  manifest   = yamldecode(<<-EOF
  kind: Ingress
  apiVersion: networking.k8s.io/v1
  metadata:
    name: jaeger
    namespace: monitoring
    annotations:
      cert-manager.io/cluster-issuer: my-cluster-issuer
      nginx.ingress.kubernetes.io/rewrite-target: /jaeger/$1
  spec:
    ingressClassName: nginx
    tls:
      - hosts:
          - ${var.hostname}
        secretName: root-certificate
    rules:
      - host: ${var.hostname}
        http:
          paths:
            - path: /jaeger/?(.*)
              pathType: ImplementationSpecific
              backend:
                service:
                  name: jaeger-query
                  port:
                    number: 16686
  EOF
  )
}

resource "kubernetes_manifest" "jaeger-service" {
  manifest   = yamldecode(<<-EOF
    apiVersion: v1
    kind: Service
    metadata:
      labels:
        name: otlp
      name: otlp
      namespace: monitoring
    spec:
      ports:
        - port: 4317
          targetPort: 4317
          name: otlp-grpc
        - port: 4318
          targetPort: 4318
          name: otlp-http
      selector:
        app.kubernetes.io/name: jaeger
  EOF
  )
}



