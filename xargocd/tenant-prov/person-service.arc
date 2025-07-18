# kubectl patch application person-service-provisioning -n argocd --type=merge -p '{"metadata":{"finalizers":null}}'
# kubectl patch job person-service-provisioning -n example --type=merge -p '{"metadata":{"finalizers":null}}'
resource "kubernetes_manifest" "person-service-provisioning" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "person-service-provisioning"
      namespace = "argocd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io",
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.helm_repository
        targetRevision = "develop"
        path           = "helm/example/spring/person-service/provisioning"
        helm = {
          valueFiles = ["../../../../../helm/values.yaml"]
          parameters = [
            {
              name  = "ingress.hosts"
              value = var.hostname
            },

            {
              name  = "oidc.enabled"
              value = local.oidc_enabled
            }

            {
              name = "postgresql.host"
              value = "postgresql.data"
            }

          ]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "example"
      }
      syncPolicy = {
        automated  = {}
        syncOptions = ["CreateNamespace=false"]
      }
    }
  }
}

