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
        targetRevision = "refactoring"
        path          = "helm/event/event-dispatcher-service/application"
        helm = {
          parameters = [
            {
              name  = "ingress.hosts"
              value = var.hostname
            },
            {
              name  = "image.arch"
              value = "-native${local.server_arch}"
            },
            {
              name  = "replicaCount"
              value = "1"
            },

            {
              name  = "oidc.enabled"
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
        namespace = "event"
      }
      syncPolicy = {
        automated  = {}
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}



