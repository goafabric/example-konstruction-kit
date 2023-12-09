resource "terraform_data" "istio" {
  provisioner "local-exec" {
    when = create
    command = "istioctl install -y --set profile=${var.profile} -f ./templates/meshconfig.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "istioctl uninstall -y --purge"
  }
}
