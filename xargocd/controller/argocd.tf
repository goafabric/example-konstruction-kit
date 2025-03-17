resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
  version    = "7.8.11"

  set {
    name  = "crds.keep"
    value = "false"
  }

#  set {
#    name  = "configs.cm.timeout.reconciliation"
#    value = "20s"
#  }
}