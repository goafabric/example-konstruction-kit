resource "kubernetes_manifest" "core-provisioning" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "core-provisioning"
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
        path           = "helm/core/core/provisioning"
        helm = {
          valueFiles = ["../../../../helm/values.yaml"]
          
          parameters = [
            {
              name  = "ingress.hosts"
              value = var.hostname
            },

            {
              name  = "oidc.enabled"
              value = local.oidc_enabled
            },
            {
              name  = "kafka.enabled"
              value = local.oidc_enabled
            },

    
            {
              name  = "messageBroker.password"
              value = "supersecret"
            },


          ]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "core"
      }
      syncPolicy = {
        automated  = {}
        syncOptions = ["CreateNamespace=false"]
      }
    }
  }
}

