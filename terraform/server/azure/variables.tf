variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 2
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

#should be set from environment
variable "subscription_id" {
  type        = string
  description = "The azure Subscription ID"
}

locals {
  resource_group_name = "eden-eve"
  cluster_name = local.resource_group_name
  resource_group_location = "Germany West Central"
}

# terraform output -raw kube_config > ~/.kube/config
