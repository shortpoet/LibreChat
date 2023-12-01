resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  address_space       = local.vnet_address_space
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = local.tags
}

resource "azurerm_subnet" "this" {
  name                 = local.subnet_name
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = local.subnet_address_prefixes

  service_endpoints = local.subnet_service_endpoints

  delegation {
    name = local.subnet_service_delegation_name
    service_delegation {
      name = local.subnet_service_delegation_type
    }
  }
}

resource "azurerm_private_dns_zone" "dns_zone" {
  count = var.private_dns_zone_name != null ? 1 : 0

  name                = var.private_dns_zone_name
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = local.tags
}
