resource "kubernetes_manifest" "person-service-application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "person-service-application"
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
        path           = "helm/example/spring/person-service/application"
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
            },
            {
              name  = "oidc.session.secret"
              value = random_password.oidc_session_secret.result
            },
            {
              name  = "database.password"
              value = random_password.postgresql_password.result
            },

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

