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
  description = "Specifies whether public network access is allowed"
  type        = bool
}

variable "app_service_sku_name" {
  type        = string
  description = "size of the VM that runs the librechat app. F1 is free but limited to 1h per day."
}

variable "debug_openai" {
  type        = bool
  description = "Flag to enable/disable debug mode for OpenAI"
}

variable "debug_plugins" {
  type        = bool
  description = "Flag to enable/disable debug mode for plugins"
}

variable "check_balance" {
  type        = bool
  description = "Flag to enable/disable balance check"
}

variable "mongo_uri" {
  type        = string
  description = "MongoDB connection string"
}

variable "openai_api_key" {
  type        = string
  description = "OpenAI API key"
}

variable "meili_master_key" {
  type        = string
  description = "Meilisearch master key"
}

variable "jwt_secret" {
  type        = string
  description = "JWT Secret"
}

variable "jwt_refresh_secret" {
  type        = string
  description = "JWT Refresh Secret"
}

variable "github_client_secret" {
  type        = string
  description = "Github client secret"
}

variable "github_client_id" {
  type        = string
  description = "Github client id"
}

variable "email_service" {
  type        = string
  description = "Email service"
}

variable "email_user" {
  type        = string
  description = "Email user"
}

variable "email_password" {
  type        = string
  description = "Email password"
}

variable "email_from" {
  type        = string
  description = "Email from"
}
