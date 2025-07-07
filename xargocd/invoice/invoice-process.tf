resource "kubernetes_manifest" "invoice-process-application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "invoice-process-application"
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
        path          = "helm/invoice/invoice-process/application"
        helm = {
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
              name  = "cache.type"
              value = local.cache_type
            },

            {
              name  = "oidc.session.secret"
              value = random_password.oidc_session_secret.result
            },


            {
              name  = "redis.password"
              value = random_password.cache_password.result
            }

          ]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "invoice"
      }
      syncPolicy = {
        automated  = {}
        syncOptions = ["CreateNamespace=false"]
      }
    }
  }
}



