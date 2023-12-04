# that's just here for backwards compatibility with the helm chart stack scripts
resource "terraform_data" "host_configmap" {
  provisioner "local-exec" {
    when = create
    command = "kubectl create configmap cluster-config -n default --from-literal=hostname=${var.hostname}"
  }
}