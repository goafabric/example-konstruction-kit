resource "helm_release" "person-service-provisioning" {
  repository = var.helm_repository
  name       = "person-service-provisioning"
  chart      = "${var.helm_repository}/example/spring/person-service/provisioning"
  namespace  = "example"
  create_namespace = false
  timeout = var.helm_timeout

  values = [
    file("../../helm/values.yaml")
  ]
  
  set {
    name  = "ingress.hosts"
    value = var.hostname
  }

  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }

  set {
    name = "postgresql.host"
    value = "postgresql.data"
  }

}


