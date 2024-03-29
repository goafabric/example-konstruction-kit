resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"
  namespace  = "monitoring"
  create_namespace = true
  version    = "5.11.0"
  wait       = false

  set {
    name  = "metricsScraper.enabled"
    value = "true"
  }
  set {
    name  = "metrics-server.enabled"
    value = "true"
  }
  set {
    name  = "metrics-server.args[0]"
    value = "--kubelet-insecure-tls"
  }
  set {
    name  = "extraArgs[0]"
    value = "--enable-skip-login"
  }
}

resource "kubernetes_manifest" "dashboard-role" {
  manifest   = yamldecode(<<-EOF
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: kubernetes-dashboard
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
      - kind: ServiceAccount
        name: kubernetes-dashboard
        namespace: monitoring
    EOF
  )
}

resource "kubernetes_manifest" "dashboard-ingress" {
#  count = var.hostname == "kind" ? 1 : 0
  manifest   = yamldecode(<<-EOF
  kind: Ingress
  apiVersion: networking.k8s.io/v1
  metadata:
    name: kubernetes-dashboard
    namespace: monitoring
    annotations:
      cert-manager.io/cluster-issuer: my-cluster-issuer
      nginx.ingress.kubernetes.io/backend-protocol: HTTPS
      nginx.ingress.kubernetes.io/rewrite-target: /$1
      service.alpha.kubernetes.io/app-protocols: '{"https":"HTTPS"}'
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
            - path: /dashboard/?(.*)
              pathType: ImplementationSpecific
              backend:
                service:
                  name: kubernetes-dashboard
                  port:
                    number: 443
  EOF
  )
}

