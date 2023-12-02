locals {
  # Common
  subscription_id      = var.subscription_id
  environment          = var.environment
  location             = var.location
  default_tags_enabled = true
  tags                 = {}
  application_name     = "openai_service_librechat_${local.environment}"

  librechat_resource_group_name = "librechat-${local.environment}"

  public_network_access_enabled = var.public_network_access_enabled

  # AI
  cognitive_account_name                  = "librechat-cognitive-${local.environment}"
  cognitive_account_custom_subdomain_name = "librechat-shortpoet-${local.environment}"
  openai_deployment = {
    "chat_model" = {
      name            = "gpt-35-turbo"
      rai_policy_name = "Microsoft.Default"
      model_name      = "gpt-35-turbo"
      model_format    = "OpenAI"
      model_version   = "0301"
      scale_type      = "Standard"
    },
    "embedding_model" = {
      name            = "text-embedding-ada-002"
      rai_policy_name = "Microsoft.Default"
      model_format    = "OpenAI"
      model_name      = "text-embedding-ada-002"
      model_version   = "2"
      scale_type      = "Standard"
    }
  }

  # Web App
  app_service_sku_name = var.app_service_sku_name
  debug_openai         = var.debug_openai
  debug_plugins        = var.debug_plugins
  mongo_uri            = var.mongo_uri
  meili_master_key     = var.meili_master_key
  jwt_secret           = var.jwt_secret
  jwt_refresh_secret   = var.jwt_refresh_secret
  openai_api_key       = var.openai_api_key
  check_balance        = var.check_balance
  github_client_secret = var.github_client_secret
  github_client_id     = var.github_client_id
  email_service        = var.email_service
  email_user           = var.email_user
  email_password       = var.email_password
  email_from           = var.email_from
}
