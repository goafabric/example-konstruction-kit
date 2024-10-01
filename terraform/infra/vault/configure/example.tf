## apps

resource "terraform_data" "create_vault_example" {
  depends_on = [vault_mount.databases]
  provisioner "local-exec" {
    when    = create
    command = "kubectl apply -f ./example-apps/vault-injector-example.yaml -n example"
  }
}

resource "terraform_data" "destroy_vault_example" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f ./example-apps/vault-injector-example.yaml -n example"
  }
}


resource "terraform_data" "create_bank_vault_example" {
  depends_on = [vault_mount.databases]
  provisioner "local-exec" {
    when    = create
    command = "kubectl apply -f ./example-apps/bank-vault-example.yaml -n example"
  }
}

resource "terraform_data" "destroy_bank_vault_example" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f ./example-apps/bank-vault-example.yaml -n example"
  }
}

