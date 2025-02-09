resource "helm_release" "person-service-application" {
  depends_on = [kubernetes_service_account.person-vault-read-account]
  repository = var.helm_repository
  name       = "person-service-application"
  chart      = "${var.helm_repository}/person-service/application"
  namespace  = "example"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "replicaCount"
    value = "1"
  }

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  # set {
  #   name  = "image.arch"
  #   value = "-native${local.server_arch}"
  # }


  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }

  set_sensitive {
    name = "oidc.session.secret"
    value = ""
  }

  set {
    name = "multiTenancy.tenants"
    value = var.multi_tenancy_tenants
  }

  set {
    name = "kubernetesClusterIdentityTenantId"
    value = var.tenant_id
  }

  set {
    name = "identityClientId"
    value = "cdf7e326-009d-4aec-bd82-1be8533126b6"
  }
  
}

resource "kubernetes_service_account" "person-vault-read-account" {
  metadata {
    name      = "vault-read-account"
    namespace = "example"
    annotations = {
      "azure.workload.identity/client-id" = "cdf7e326-009d-4aec-bd82-1be8533126b6"
    }
  }
}


