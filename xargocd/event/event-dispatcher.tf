resource "kubernetes_manifest" "event-dispatcher-service-application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "event-dispatcher-service-application"
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
        path          = "helm/event/event-dispatcher-service/application"
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
              name  = "oidc.session.secret"
              value = random_password.oidc_session_secret.result
            }


          ]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "event"
      }
      syncPolicy = {
        automated  = {}
        syncOptions = ["CreateNamespace=false"]
      }
    }
  }
}



