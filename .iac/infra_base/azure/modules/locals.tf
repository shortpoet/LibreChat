locals {
  # Common
  subscription_id                = var.subscription_id
  environment                    = var.environment
  location                       = var.location
  networking_resource_group_name = "librechat-network-${local.environment}"

}
