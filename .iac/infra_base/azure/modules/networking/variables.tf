variable "subscription_id" {
  type        = string
  description = "The subscription ID to use for the Azure resources"
}

variable "environment" {
  type        = string
  description = "Environment of the application. A corresponding tag would be created on the created resources if `var.default_tags_enabled` is `true`."
}

variable "location" {
  description = "The location where all resources will be deployed"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources"
}

variable "use_cosmosdb_free_tier" {
  description = "Flag to enable/disable free tier of cosmosdb. This needs to be false if another instance already uses free tier."
  default     = true
}

variable "public_network_access_enabled" {
  description = "(Optional) Specifies whether public network access is allowed"
  type        = bool
  default     = false
}
