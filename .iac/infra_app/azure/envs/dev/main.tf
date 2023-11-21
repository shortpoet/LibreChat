resource "azurerm_resource_group" "librechat" {
  name     = local.librechat_resource_group_name
  location = local.location
}

module "openai" {
  # application_name = "openai_service_librechat"
  source = "../../modules/networking"

  subscription_id               = local.subscription_id
  environment                   = local.environment
  resource_group_name           = azurerm_resource_group.librechat.name
  location                      = azurerm_resource_group.librechat.location
  public_network_access_enabled = true
  # private_endpoint = {
  #   "pe_endpoint" = {
  #     private_dns_entry_enabled       = true
  #     dns_zone_virtual_network_link   = "dns_zone_link_openai"
  #     is_manual_connection            = false
  #     name                            = "openai_pe"
  #     private_service_connection_name = "openai_pe_connection"
  #     subnet_name                     = "subnet0"
  #     vnet_name                       = module.vnet.vnet_name
  #     vnet_rg_name                    = azurerm_resource_group.this.name
  #   }
  # }
  deployment = var.deployments
  depends_on = [
    azurerm_resource_group.this,
    # module.vnet
  ]
}
