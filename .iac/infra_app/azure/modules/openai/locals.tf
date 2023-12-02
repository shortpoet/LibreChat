locals {
  # Resource Group
  location = coalesce(var.location, data.azurerm_resource_group.this.location)

  # Cognitive Account
  account_name          = var.account_name
  custom_subdomain_name = var.custom_subdomain_name
  tags = merge(var.default_tags_enabled ? {
    Application_Name = var.application_name
    Environment      = var.environment
  } : {}, var.tags)

}
