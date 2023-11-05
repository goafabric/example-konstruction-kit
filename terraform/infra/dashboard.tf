resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"
  namespace  = "monitoring"
  version    = "5.11.0"

  values = [file("dashboard-values.yml")]

  set {
    name  = "ingress.hosts[0]"
    value = var.hostname  # Replace with your actual value
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = var.hostname  # Replace with your actual value
  }
}

resource "kubernetes_manifest" "dashboard" {
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