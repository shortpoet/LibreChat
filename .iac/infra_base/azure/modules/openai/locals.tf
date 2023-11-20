locals {
  # Resource Group
  location = coalesce(var.location, data.azurerm_resource_group.this.location)

  # Cognitive Account
  account_name          = coalesce(var.account_name, "azure-openai-${random_integer.this.result}")
  custom_subdomain_name = coalesce(var.custom_subdomain_name, "azure-openai-${random_integer.this.result}")
  tags = merge(var.default_tags_enabled ? {
    Application_Name = var.application_name
    Environment      = var.environment
  } : {}, var.tags)

  # Private Endpoint
  private_dns_zone_id   = length(var.private_endpoint) > 0 ? try(azurerm_private_dns_zone.dns_zone[0].id, data.azurerm_private_dns_zone.dns_zone[0].id) : null
  private_dns_zone_name = length(var.private_endpoint) > 0 ? try(azurerm_private_dns_zone.dns_zone[0].name, data.azurerm_private_dns_zone.dns_zone[0].name) : null

}
