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


}


