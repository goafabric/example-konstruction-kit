resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"
  namespace  = "monitoring"
  version    = "5.11.0"
  wait       = false

  values = [file("dashboard-values.yml")]
}

resource "kubernetes_manifest" "dashboard-ingress" {
  manifest   = yamldecode(
  <<-EOF
  kind: Ingress
  apiVersion: networking.k8s.io/v1
  metadata:
    name: kubernetes-dashboard
    namespace: monitoring
    annotations:
      cert-manager.io/cluster-issuer: my-cluster-issuer
      nginx.ingress.kubernetes.io/auth-secret: authentication-secret
      nginx.ingress.kubernetes.io/auth-type: basic
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

resource "kubernetes_manifest" "dashboard-role" {
  manifest   = yamldecode(
    <<-EOF
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