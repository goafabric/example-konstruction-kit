resource "kubernetes_manifest" "core-application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "core-application"
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
        path           = "helm/core/core/application"
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
              name  = "oidc.session.secret"
              value = random_password.oidc_session_secret.result
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


resource "kubernetes_manifest" "core-frontend" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "core-frontend"
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
        path           = "helm/core/core/frontend"
        helm = {
          parameters = [
            {
              name  = "ingress.hosts"
              value = var.hostname
            },
            {
              name  = "maxReplicas"
              value = "3"
            },

            {
              name  = "oidc.enabled"
              value = local.oidc_enabled
            },
            {
              name  = "kafka.enabled"
              value = "true"
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
        namespace = "core"
      }
      syncPolicy = {
        automated  = {}
        syncOptions = ["CreateNamespace=false"]
      }
    }
  }
}


