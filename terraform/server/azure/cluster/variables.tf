#should be set from environment
variable "subscription_id" {
  type        = string
}

#should be set from environment
variable "tenant_id" {
  type        = string
}

variable "resource_group_location" {
  type        = string
  default     = "Germany West Central"
}

variable "resource_group_name" {
  type        = string
}

variable "default_node_count" {
  type        = number
  default     = 1
}

variable "default_vm_size" {
  type        = string
  default     = "Standard_D4ds_v5"
}

