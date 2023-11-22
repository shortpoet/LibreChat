locals {
  # Common
  subscription_id               = var.subscription_id
  environment                   = var.environment
  location                      = var.location
  application_name              = "openai_service_librechat_${local.environment}"
  app_title                     = "LibreChat-Shortpoet"
  librechat_resource_group_name = "librechat-${local.environment}"

  # Networking
  librechat_vnet_name               = "librechat-vnet-${local.environment}"
  librechat_vnet_address_space      = ["10.0.0.0/16"]
  librechat_subnet_name             = "librechat-subnet-${local.environment}"
  librechat_subnet_address_prefixes = ["10.0.1.0/24"]

  # Tags

  tags = merge(var.default_tags_enabled ? {
    Application_Name = local.application_name
    Environment      = local.environment
    App_Title        = local.app_title
  } : {}, var.tags)

}
