resource "azurerm_resource_group" "networking" {
  name     = local.networking_resource_group_name
  location = local.location
}

module "networking" {

  source = "../../modules/networking"

  subscription_id     = local.subscription_id
  environment         = local.environment
  resource_group_name = azurerm_resource_group.networking.name

  private_dns_zone_name = local.private_dns_zone_name

  depends_on = [azurerm_resource_group.networking]
}
