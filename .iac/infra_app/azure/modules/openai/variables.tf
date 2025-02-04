## Common ########################
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
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources"
}

variable "application_name" {
  type        = string
  default     = ""
  description = "Name of the application. A corresponding tag would be created on the created resources if `var.default_tags_enabled` is `true`."
}

variable "default_tags_enabled" {
  type        = bool
  default     = false
  description = "Determines whether or not default tags are applied to resources. If set to true, tags will be applied. If set to false, tags will not be applied."
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resource."
  nullable    = false
}

## Cognitive Account ########################
variable "account_name" {
  type        = string
  description = "Specifies the name of the Cognitive Service Account. Changing this forces a new resource to be created."
}

variable "custom_subdomain_name" {
  type        = string
  description = "The subdomain name used for token-based authentication. Changing this forces a new resource to be created."
}

variable "customer_managed_key" {
  type = object({
    key_vault_key_id   = string
    identity_client_id = optional(string)
  })
  default     = null
  description = <<-DESCRIPTION
    type = object({
      key_vault_key_id   = (Required) The ID of the Key Vault Key which should be used to Encrypt the data in this OpenAI Account.
      identity_client_id = (Optional) The Client ID of the User Assigned Identity that has access to the key. This property only needs to be specified when there're multiple identities attached to the OpenAI Account.
    })
  DESCRIPTION
}

variable "deployment" {
  type = map(object({
    name            = string
    model_format    = string
    model_name      = string
    model_version   = string
    scale_type      = string
    rai_policy_name = optional(string)
    capacity        = optional(number)
  }))
  default     = {}
  description = <<-DESCRIPTION
      type = map(object({
        name                 = (Required) The name of the Cognitive Services Account Deployment. Changing this forces a new resource to be created.
        cognitive_account_id = (Required) The ID of the Cognitive Services Account. Changing this forces a new resource to be created.
        model = {
          model_format  = (Required) The format of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created. Possible value is OpenAI.
          model_name    = (Required) The name of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created.
          model_version = (Required) The version of Cognitive Services Account Deployment model.
        }
        scale = {
          scale_type = (Required) Deployment scale type. Possible value is Standard. Changing this forces a new resource to be created.
        }
        rai_policy_name = (Optional) The name of RAI policy. Changing this forces a new resource to be created.
        capacity = (Optional) Tokens-per-Minute (TPM). The unit of measure for this field is in the thousands of Tokens-per-Minute. Defaults to 1 which means that the limitation is 1000 tokens per minute.
      }))
  DESCRIPTION
  nullable    = false
}

variable "diagnostic_setting" {
  type = map(object({
    name                           = string
    log_analytics_workspace_id     = optional(string)
    log_analytics_destination_type = optional(string)
    eventhub_name                  = optional(string)
    eventhub_authorization_rule_id = optional(string)
    storage_account_id             = optional(string)
    partner_solution_id            = optional(string)
    audit_log_retention_policy = optional(object({
      enabled = optional(bool, true)
      days    = optional(number, 7)
    }))
    request_response_log_retention_policy = optional(object({
      enabled = optional(bool, true)
      days    = optional(number, 7)
    }))
    trace_log_retention_policy = optional(object({
      enabled = optional(bool, true)
      days    = optional(number, 7)
    }))
    metric_retention_policy = optional(object({
      enabled = optional(bool, true)
      days    = optional(number, 7)
    }))
  }))
  default     = {}
  description = <<-DESCRIPTION
  A map of objects that represent the configuration for a diagnostic setting."
  type = map(object({
    name                                  = (Required) Specifies the name of the diagnostic setting. Changing this forces a new resource to be created.
    log_analytics_workspace_id            = (Optional) (Optional) Specifies the resource id of an Azure Log Analytics workspace where diagnostics data should be sent.
    log_analytics_destination_type        = (Optional) Possible values are `AzureDiagnostics` and `Dedicated`. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy `AzureDiagnostics` table.
    eventhub_name                         = (Optional) Specifies the name of the Event Hub where diagnostics data should be sent.
    eventhub_authorization_rule_id        = (Optional) Specifies the resource id of an Event Hub Namespace Authorization Rule used to send diagnostics data.
    storage_account_id                    = (Optional) Specifies the resource id of an Azure storage account where diagnostics data should be sent.
    partner_solution_id                   = (Optional) The resource id of the market partner solution where diagnostics data should be sent. For potential partner integrations, click to learn more about partner integration.
    audit_log_retention_policy            = (Optional) Specifies the retention policy for the audit log. This is a block with the following properties:
      enabled                             = (Optional) Specifies whether the retention policy is enabled. If enabled, `days` must be a positive number.
      days                                = (Optional) Specifies the number of days to retain trace logs. If `enabled` is set to `true`, this value must be set to a positive number.
    request_response_log_retention_policy = (Optional) Specifies the retention policy for the request response log. This is a block with the following properties:
      enabled                             = (Optional) Specifies whether the retention policy is enabled. If enabled, `days` must be a positive number.
      days                                = (Optional) Specifies the number of days to retain trace logs. If `enabled` is set to `true`, this value must be set to a positive number.
    trace_log_retention_policy            = (Optional) Specifies the retention policy for the trace log. This is a block with the following properties:
      enabled                             = (Optional) Specifies whether the retention policy is enabled. If enabled, `days` must be a positive number.
      days                                = (Optional) Specifies the number of days to retain trace logs. If `enabled` is set to `true`, this value must be set to a positive number.
    metric_retention_policy               = (Optional) Specifies the retention policy for the metric. This is a block with the following properties:
      enabled                             = (Optional) Specifies whether the retention policy is enabled. If enabled, `days` must be a positive number.
      days                                = (Optional) Specifies the number of days to retain trace logs. If `enabled` is set to `true`, this value must be set to a positive number.
  }))
DESCRIPTION
  nullable    = false
}

variable "dynamic_throttling_enabled" {
  type        = bool
  default     = null
  description = "Determines whether or not dynamic throttling is enabled. If set to `true`, dynamic throttling will be enabled. If set to `false`, dynamic throttling will not be enabled."
}

variable "fqdns" {
  type        = list(string)
  default     = null
  description = "List of FQDNs allowed for the Cognitive Account."
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default     = null
  description = <<-DESCRIPTION
    type = object({
      type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.
      identity_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.
    })
  DESCRIPTION
}

variable "local_auth_enabled" {
  type        = bool
  default     = true
  description = "Whether local authentication methods is enabled for the Cognitive Account. Defaults to `true`."
}

variable "network_acls" {
  type = set(object({
    default_action = string
    ip_rules       = optional(set(string))
    virtual_network_rules = optional(set(object({
      subnet_id                            = string
      ignore_missing_vnet_service_endpoint = optional(bool, false)
    })))
  }))
  default     = null
  description = <<-DESCRIPTION
    type = set(object({
      default_action = (Required) The Default Action to use when no rules match from ip_rules / virtual_network_rules. Possible values are `Allow` and `Deny`.
      ip_rules                    = (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Cognitive Account.
      virtual_network_rules = optional(set(object({
        subnet_id                            = (Required) The ID of a Subnet which should be able to access the OpenAI Account.
        ignore_missing_vnet_service_endpoint = (Optional) Whether ignore missing vnet service endpoint or not. Default to `false`.
      })))
    }))
  DESCRIPTION
}

variable "outbound_network_access_restricted" {
  type        = bool
  default     = false
  description = "Whether outbound network access is restricted for the Cognitive Account. Defaults to `false`."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether public network access is allowed for the Cognitive Account. Defaults to `false`."
}

variable "sku_name" {
  type        = string
  default     = "S0"
  description = "Specifies the SKU Name for this Cognitive Service Account. Possible values are `F0`, `F1`, `S0`, `S`, `S1`, `S2`, `S3`, `S4`, `S5`, `S6`, `P0`, `P1`, `P2`, `E0` and `DC0`. Default to `S0`."
}

variable "storage" {
  type = list(object({
    storage_account_id = string
    identity_client_id = optional(string)
  }))
  default     = []
  description = <<-DESCRIPTION
    type = list(object({
      storage_account_id = (Required) Full resource id of a Microsoft.Storage resource.
      identity_client_id = (Optional) The client ID of the managed identity associated with the storage resource.
    }))
  DESCRIPTION
  nullable    = false
}
