/*
resource "terraform_data" "linkerd-viz" {
  depends_on = [terraform_data.linkerd]
  provisioner "local-exec" {
    when = create
    command = "linkerd viz install | kubectl apply -f -"
  }

  provisioner "local-exec" {
    when = destroy
    command = "linkerd viz uninstall | kubectl delete -f -"
  }
}
*/
