resource "terraform_data" "create_example" {
  depends_on = [terraform_data.create_stack]
  provisioner "local-exec" {
    when    = create
    command = "kubectl apply -f ./example-apps/deployment.yaml -n example"
  }
}

resource "terraform_data" "destroy_example" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f ./example-apps/deployment.yaml -n example"
  }
}