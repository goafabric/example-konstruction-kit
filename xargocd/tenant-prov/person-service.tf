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
          valueFiles = ["../../../../../xargocd/tenant-prov/values.yaml"]
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
              value = data.kubernetes_secret.postgresql_secret.data["password"]
            },
            

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

