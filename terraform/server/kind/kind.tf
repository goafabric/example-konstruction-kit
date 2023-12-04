resource "terraform_data" "kind" {
  provisioner "local-exec" {
    when = create
    command = "./server-create"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kind delete cluster"
  }
}


