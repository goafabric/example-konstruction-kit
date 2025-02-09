resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = local.cluster_name
  dns_prefix          = "myaks"
  kubernetes_version  = "1.30"

  key_vault_secrets_provider { # enables csi driver
    secret_rotation_enabled  = "true"
    secret_rotation_interval = "2m"
  }

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                = "agentpool"
    vm_size             = var.default_vm_size
    node_count          = var.default_node_count

    upgrade_settings {
      drain_timeout_in_minutes      = 15
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  network_profile { #important for network policies
    network_plugin      = "azure"
    network_policy      = "calico"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"

    # load_balancer_profile {
    #   outbound_ip_address_ids = [azurerm_public_ip.aks_public_ip.id]
    # }

  }
}

# resource "azurerm_public_ip" "aks_public_ip" {
#   name                = "aks-public-ip"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
#
#   domain_name_label = local.cluster_name
# }

output "kube_config" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}
