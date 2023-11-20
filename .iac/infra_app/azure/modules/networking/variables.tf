variable "subscription_id" {
  type        = string
  description = "The subscription ID to use for the Azure resources"
}

variable "environment" {
  type        = string
  description = "Environment of the application. A corresponding tag would be created on the created resources if `var.default_tags_enabled` is `true`."
}

variable "location" {
  description = "The location where all resources will be deployed"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources"
}

variable "default_tags_enabled" {
  type        = bool
  default     = false
  description = "Determines whether or not default tags are applied to resources. If set to true, tags will be applied. If set to false, tags will not be applied."
  nullable    = false
}

variable "application_name" {
  type        = string
  default     = ""
  description = "Name of the application. A corresponding tag would be created on the created resources if `var.default_tags_enabled` is `true`."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resource."
  nullable    = false
}

variable "private_endpoint" {
  type = map(object({
    name                               = string
    vnet_rg_name                       = string
    vnet_name                          = string
    subnet_name                        = string
    dns_zone_virtual_network_link_name = optional(string, "dns_zone_link")
    private_dns_entry_enabled          = optional(bool, false)
    private_service_connection_name    = optional(string, "privateserviceconnection")
    is_manual_connection               = optional(bool, false)
  }))
  default     = {}
  description = <<-DESCRIPTION
  A map of objects that represent the configuration for a private endpoint."
  type = map(object({
    name                               = (Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created.
    vnet_rg_name                       = (Required) Specifies the name of the Resource Group where the Private Endpoint's Virtual Network Subnet exists. Changing this forces a new resource to be created.
    vnet_name                          = (Required) Specifies the name of the Virtual Network where the Private Endpoint's Subnet exists. Changing this forces a new resource to be created.
    subnet_name                        = (Required) Specifies the name of the Subnet which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created.
    dns_zone_virtual_network_link_name = (Optional) The name of the Private DNS Zone Virtual Network Link. Changing this forces a new resource to be created. Default to `dns_zone_link`.
    private_dns_entry_enabled          = (Optional) Whether or not to create a `private_dns_zone_group` block for the Private Endpoint. Default to `false`.
    private_service_connection_name    = (Optional) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created. Default to `privateserviceconnection`.
    is_manual_connection               = (Optional) Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created. Default to `false`.
  }))
DESCRIPTION
  nullable    = false
}

variable "pe_subresource" {
  type        = list(string)
  default     = ["account"]
  description = "A list of subresource names which the Private Endpoint is able to connect to. `subresource_names` corresponds to `group_id`. Possible values are detailed in the product [documentation](https://docs.microsoft.com/azure/private-link/private-endpoint-overview#private-link-resource) in the `Subresources` column. Changing this forces a new resource to be created."
}

variable "private_dns_zone" {
  type = object({
    name                = string
    resource_group_name = optional(string)
  })
  default     = null
  description = <<-DESCRIPTION
  A map of object that represents the existing Private DNS Zone you'd like to use. Leave this variable as default would create a new Private DNS Zone.
  type = object({
    name                = "(Required) The name of the Private DNS Zone."
    resource_group_name = "(Optional) The Name of the Resource Group where the Private DNS Zone exists. If the Name of the Resource Group is not provided, the first Private DNS Zone from the list of Private DNS Zones in your subscription that matches `name` will be returned."
  }
DESCRIPTION
}

variable "private_endpoint" {
  type = map(object({
    name                               = string
    vnet_rg_name                       = string
    vnet_name                          = string
    subnet_name                        = string
    dns_zone_virtual_network_link_name = optional(string, "dns_zone_link")
    private_dns_entry_enabled          = optional(bool, false)
    private_service_connection_name    = optional(string, "privateserviceconnection")
    is_manual_connection               = optional(bool, false)
  }))
  default     = {}
  description = <<-DESCRIPTION
  A map of objects that represent the configuration for a private endpoint."
  type = map(object({
    name                               = (Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created.
    vnet_rg_name                       = (Required) Specifies the name of the Resource Group where the Private Endpoint's Virtual Network Subnet exists. Changing this forces a new resource to be created.
    vnet_name                          = (Required) Specifies the name of the Virtual Network where the Private Endpoint's Subnet exists. Changing this forces a new resource to be created.
    subnet_name                        = (Required) Specifies the name of the Subnet which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created.
    dns_zone_virtual_network_link_name = (Optional) The name of the Private DNS Zone Virtual Network Link. Changing this forces a new resource to be created. Default to `dns_zone_link`.
    private_dns_entry_enabled          = (Optional) Whether or not to create a `private_dns_zone_group` block for the Private Endpoint. Default to `false`.
    private_service_connection_name    = (Optional) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created. Default to `privateserviceconnection`.
    is_manual_connection               = (Optional) Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created. Default to `false`.
  }))
DESCRIPTION
  nullable    = false
}

variable "custom_subdomain_name" {
  type        = string
  default     = ""
  description = "The subdomain name used for token-based authentication. Changing this forces a new resource to be created. Leave this variable as default would use a default name with random suffix."
}
