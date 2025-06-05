resource "helm_release" "person-service-application" {
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
  #   value = "-native"
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

  # required variables for vault
  set {
    name = "kubernetesClusterIdentityTenantId"
    value = var.tenant_id
  }

  set {
    name = "identityClientId"
    value = data.azurerm_user_assigned_identity.key_vault_identity.client_id
  }

  set {
    name = "keyVault.name"
    value = "${var.resource_group_name}-vault"
  }

  set {
    name = "datasource.url"
    value = "jdbc:postgresql://${var.resource_group_name}-postgres.postgres.database.azure.com:5432/postgres?sslmode=require"
  }

}


