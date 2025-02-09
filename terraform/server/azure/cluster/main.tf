terraform {
  required_version = ">=1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id

  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

resource "null_resource" "set_kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.k8s]
  provisioner "local-exec" {
    when = create
    command = "terraform output -raw kube_config > ~/.kube/config"
  }
}