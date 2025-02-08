# Generate random resource group name
resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = azurerm_resource_group.rg.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id
  kubernetes_version  = "1.30"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = var.default_vm_size
    node_count = var.default_node_count
  }

  # linux_profile {
  #   admin_username = var.username
  #
  #   ssh_key {
  #     key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
  #   }
  # }

  network_profile {
    network_plugin      = "azure"
    network_policy      = "calico"
    network_plugin_mode = "overlay"

    load_balancer_sku = "standard"
  }
}