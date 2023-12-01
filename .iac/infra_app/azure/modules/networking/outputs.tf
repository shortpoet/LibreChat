output "private_ip_addresses" {
  description = "A map dictionary of the private IP addresses for each private endpoint."
  value = {
    for key, pe in azurerm_private_endpoint.this : key => pe.private_service_connection[0].private_ip_address
  }
}
