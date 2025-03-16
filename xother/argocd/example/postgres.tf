resource "kubernetes_manifest" "person-service-postgres" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "person-service-postgres-postgresql-ha-pgpool"
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
        path           = "helm/example/spring/person-service/postgres"
        helm = {
          parameters = [
            {
              name  = "maxReplicas"
              value = "3"
            },
            {
              name  = "database.password"
              value = random_password.postgres_password.result
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