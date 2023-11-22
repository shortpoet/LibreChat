locals {
  # Common
  subscription_id = var.subscription_id
  environment     = var.environment
  location        = var.location

  librechat_resource_group_name = "librechat-${local.environment}"

  application_name = "openai_service_librechat_${local.environment}"
}
