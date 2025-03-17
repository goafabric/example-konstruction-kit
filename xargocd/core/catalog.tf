resource "kubernetes_manifest" "catalog-application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "catalog-application"
      namespace = "argocd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io",
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.helm_repository
        targetRevision = "data"
        path           = "helm/core/catalog/application"
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
              name  = "maxReplicas"
              value = "3"
            },

            {
              name  = "oidc.enabled"
              value = local.oidc_enabled
            },

            {
              name  = "oidc.session.secret"
              value = random_password.oidc_session_secret.result
            },
            {
              name  = "database.password"
              value = random_password.core_database_password.result
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


resource "kubernetes_manifest" "catalog-batch" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "catalog-batch"
      namespace = "argocd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io",
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.helm_repository
        targetRevision = "data"
        path           = "helm/core/catalog/batch"
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
              name  = "maxReplicas"
              value = "3"
            },

            {
              name  = "oidc.enabled"
              value = local.oidc_enabled
            },

            {
              name  = "oidc.session.secret"
              value = random_password.oidc_session_secret.result
            },
            {
              name  = "database.password"
              value = random_password.core_database_password.result
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



