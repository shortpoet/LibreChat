locals {
  # Common
  subscription_id     = var.subscription_id
  environment         = var.environment
  location            = var.location
  application_name    = "openai_service_${local.environment}"
  app_title           = "LibreChat-Shortpoet"
  resource_group_name = "librechat-${local.environment}"

  # Networking
  vnet_name                      = "librechat-vnet-${local.environment}"
  vnet_address_space             = ["10.0.0.0/16"]
  subnet_name                    = "librechat-subnet-${local.environment}"
  subnet_address_prefixes        = ["10.0.1.0/24"]
  subnet_service_endpoints       = ["Microsoft.AzureCosmosDB", "Microsoft.Web"]
  subnet_service_delegation_name = "delegation"
  subnet_service_delegation_type = "Microsoft.Web/serverFarms"

  # Tags

  tags = merge(var.default_tags_enabled ? {
    Application_Name = local.application_name
    Environment      = local.environment
    App_Title        = local.app_title
  } : {}, var.tags)

}
