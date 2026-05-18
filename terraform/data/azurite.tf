resource "helm_release" "azurite" {
  name       = "azurite"
  repository = "oci://ghcr.io/emberstack/helm-charts"
  chart      = "azurite"
  namespace  = "data"
  version    = "1.0.20"
  timeout = 60

  set {
    name  = "config.extraEnvVars[0].name"
    value = "TZ"
  }
  set {
    name  = "config.extraEnvVars[0].value"
    value = "Europe/Berlin"
  }
  
  set {
    name  = "readinessProbe.initialDelaySeconds"
    value = "2"
  }

  set {
    name  = "configuration.blobEnabled"
    value = true
  }

  set {
    name  = "configuration.queueEnabled"
    value = false
  }

  set {
    name  = "configuration.tableEnabled"
    value = false
  }


  set {
    name = "podLabels.app"
    value = "azurite"
  }

}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_azurite_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc azurite -n data"
  }
}