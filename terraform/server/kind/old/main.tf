resource "terraform_data" "kind" {
  provisioner "local-exec" {
    when = create
    command = "./kind-create"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kind delete cluster"
  }
}
