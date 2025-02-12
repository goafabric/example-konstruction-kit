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


