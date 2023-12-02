data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_private_dns_zone" "dns_zone" {
  count = length(var.private_endpoint) > 0 && var.private_dns_zone != null ? 1 : 0

  name                = var.private_dns_zone.name
  resource_group_name = var.private_dns_zone.resource_group_name
}

# Private endpoint data dependencies 
# Subnet where PE will be created 
data "azurerm_subnet" "pe_subnet" {
  for_each = var.private_endpoint

  name                 = each.value.subnet_name
  resource_group_name  = each.value.vnet_rg_name
  virtual_network_name = each.value.vnet_name
}

# Resource group of the VNET-Subnet where PE will be created 
data "azurerm_resource_group" "pe_vnet_rg" {
  for_each = var.private_endpoint

  name = each.value.vnet_rg_name
}

data "azurerm_virtual_network" "vnet" {
  for_each = var.private_endpoint

  name                = each.value.vnet_name
  resource_group_name = each.value.vnet_rg_name
}
