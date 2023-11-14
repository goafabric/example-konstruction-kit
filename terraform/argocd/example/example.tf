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


resource "helm_release" "callee-service-application" {
  repository = var.helm_repository
  name       = "callee-service-application"
  chart      = "${var.helm_repository}/callee-service/application"
  version    = "1.1.1"
  namespace  = "example"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image.arch"
    value = "-native${var.server_arch}"
  }
  set {
    name  = "replicaCount"
    value = "1"
  }
}

resource "helm_release" "person-service-postgres" {
  repository = var.helm_repository
  name       = "person-service-postgres"
  chart      = "${var.helm_repository}/person-service/postgres"
  version    = "1.1.1"
  namespace  = "example"
  create_namespace = true
  timeout = var.helm_timeout
}

resource "helm_release" "person-service-application" {
  repository = var.helm_repository
  name       = "person-service-application"
  chart      = "${var.helm_repository}/person-service/application"
  version    = "1.1.1"
  namespace  = "example"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image.arch"
    value = "-native${var.server_arch}"
  }
}