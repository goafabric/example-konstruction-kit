resource "helm_release" "kiali" {
  name       = "kiali"
  repository = "https://kiali.org/helm-charts"
  chart      = "kiali-server"
  namespace  = "istio-system"
  create_namespace = false
  version    = "1.76.0"
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
    value = "http://tracing.monitoring:16685/jaeger"
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


resource "kubernetes_manifest" "kiali-ingress" {
  manifest   = yamldecode(<<-EOF
  kind: Ingress
  apiVersion: networking.k8s.io/v1
  metadata:
    name: kiali-ingress
    namespace: istio-system
    annotations:
      cert-manager.io/cluster-issuer: my-cluster-issuer
      nginx.ingress.kubernetes.io/rewrite-target: /kiali/$1
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
            - path: /kiali/?(.*)
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
  provisioner "local-exec" {
    when = create
    command = "kubectl apply -f ./templates/prometheus.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete --ignore-not-found -f ./templates/prometheus.yaml"
  }
}

