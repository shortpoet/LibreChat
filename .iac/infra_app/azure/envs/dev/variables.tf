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
}

variable "use_cosmosdb" {
  type        = bool
  description = "Flag to enable/disable cosmosdb"
}

variable "use_cosmosdb_free_tier" {
  description = "Flag to enable/disable free tier of cosmosdb. This needs to be false if another instance already uses free tier."
  type        = bool
}

variable "public_network_access_enabled" {
  description = "(Optional) Specifies whether public network access is allowed"
  type        = bool
}
