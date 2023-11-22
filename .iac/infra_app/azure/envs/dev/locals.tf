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

}
