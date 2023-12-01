output "vnet" {
  value = azurerm_virtual_network.this
}

output "subnet" {
  value = azurerm_subnet.this
}

output "private_dns_zone" {
  value = azurerm_private_dns_zone.dns_zone
}
