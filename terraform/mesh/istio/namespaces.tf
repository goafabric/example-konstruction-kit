resource "terraform_data" "namespaces" {
  provisioner "local-exec" {
    when = create
    command = "kubectl delete ns example --ignore-not-found  && kubectl create ns example"
  }

  provisioner "local-exec" {
    when = create
    command = "kubectl delete ns core --ignore-not-found && kubectl create ns core"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete --ignore-not-found -f ./templates"
  }
}