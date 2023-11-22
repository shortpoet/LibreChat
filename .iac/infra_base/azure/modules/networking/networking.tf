resource "azurerm_virtual_network" "librechat_network" {
  name                = local.librechat_vnet_name
  address_space       = local.librechat_vnet_address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}

resource "azurerm_subnet" "librechat_subnet" {
  name                 = local.librechat_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.librechat_network.name
  address_prefixes     = local.librechat_subnet_address_prefixes

  service_endpoints = ["Microsoft.AzureCosmosDB", "Microsoft.Web"]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_private_dns_zone" "dns_zone" {
  count = var.private_dns_zone_name != null ? 1 : 0

  name                = var.private_dns_zone_name
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = local.tags
}
