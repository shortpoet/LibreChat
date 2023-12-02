locals {
  # Common
  subscription_id = var.subscription_id
  environment     = var.environment
  location        = coalesce(var.location, data.azurerm_resource_group.this.location)
  app_title       = "LibreChat-Shortpoet"

  # Resource Group
  librechat_resource_group_name = "librechat-${local.environment}"

  # Networking
  librechat_vnet_name               = "librechat-vnet-${local.environment}"
  librechat_vnet_address_space      = ["10.0.0.0/16"]
  librechat_subnet_name             = "librechat-subnet-${local.environment}"
  librechat_subnet_address_prefixes = ["10.0.1.0/24"]

  # Private Endpoint
  private_dns_zone_id   = length(var.private_endpoint) > 0 ? data.azurerm_private_dns_zone.dns_zone[0].id : null
  private_dns_zone_name = length(var.private_endpoint) > 0 ? data.azurerm_private_dns_zone.dns_zone[0].name : null

  # Cognitive Account
  tags = merge(var.default_tags_enabled ? {
    Application_Name = var.application_name
    Environment      = var.environment
  } : {}, var.tags)

}
