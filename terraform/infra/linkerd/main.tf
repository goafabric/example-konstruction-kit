resource "terraform_data" "linkerd" {
  provisioner "local-exec" {
    when = create
    command = "linkerd install --crds | kubectl apply -f -"
  }

  provisioner "local-exec" {
    when = create
    command = "linkerd install --set proxyInit.runAsRoot=true | kubectl apply -f -"
  }

  provisioner "local-exec" {
    when = destroy
    command = "linkerd uninstall | kubectl delete -f -"
  }

}
