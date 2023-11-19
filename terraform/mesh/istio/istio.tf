resource "terraform_data" "linkerd" {
  provisioner "local-exec" {
    when = create
    command = "istioctl install -y --set profile=${var.profile}"
  }


  provisioner "local-exec" {
    when = destroy
    command = "istioctl uninstall -y --purge"
  }
}