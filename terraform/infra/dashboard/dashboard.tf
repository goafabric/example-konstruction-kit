resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"
  namespace  = "dashboard"
  create_namespace = false
  version    = "6.0.8"
  wait       = false

  set {
    name  = "metricsScraper.enabled"
    value = "true"
  }
  set {
    name  = "metrics-server.enabled"
    value = "false"
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
        namespace: dashboard
    EOF
  )
}