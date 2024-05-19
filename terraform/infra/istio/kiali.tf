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
    name  = "external_services.tracing.in_cluster_url"
    value = "http://jaeger-collector.monitoring:16685/jaeger"
  }
  set {
    name  = "external_services.tracing.use_grpc"
    value = "true"
  }

  set {
    name  = "server.web_root"
    value = "/kiali"
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



resource "terraform_data" "prometheus" {
  depends_on = [kubernetes_manifest.kiali-ingress]
  provisioner "local-exec" {
    when = create
    command = "kubectl apply -f ./templates/prometheus.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete --ignore-not-found -f ./templates/prometheus.yaml"
  }
}

