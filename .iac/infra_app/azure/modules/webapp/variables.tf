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
  default     = "westeurope"
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

## Networking ###########################

variable "app_service_subnet_id" {
  type        = string
  description = "The ID of the subnet where the app service will be deployed"
}

## App ########################
variable "app_title" {
  description = "The title that librechat will display"
  default     = "librechat"
}

variable "app_service_sku_name" {
  description = "size of the VM that runs the librechat app. F1 is free but limited to 1h per day."
  default     = "B1"
}

variable "openai_key" {
  description = "OpenAI API Key"
  default     = ""
  sensitive   = true
}

variable "chatgpt_token" {
  description = "ChatGPT Token"
  default     = "user_provided"
  sensitive   = true
}

variable "anthropic_api_key" {
  description = "Anthropic API Key"
  default     = "user_provided"
  sensitive   = true
}

variable "bingai_token" {
  description = "BingAI Token"
  default     = "user_provided"
  sensitive   = true
}

variable "palm_key" {
  description = "PaLM Key"
  default     = "user_provided"
  sensitive   = true
}

variable "plugin_creds_key" {
  description = "Plugin Creds Key"
  default     = "f34be427ebb29de8d88c107a71546019685ed8b241d8f2ed00c3df97ad2566f0"
  sensitive   = true
}

variable "plugin_creds_iv" {
  description = "Plugin Creds IV"
  default     = "e2341419ec3dd3d19b13a1a87fafcbfb"
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT Secret"
  default     = "16f8c0ef4a5d391b26034086c628469d3f9f497f08163ab9b40137092f2909ef"
  sensitive   = true
}

variable "jwt_refresh_secret" {
  description = "JWT Refresh Secret"
  default     = "eaa5191f2914e30b9387fd84e254e4ba6fc51b4654968a9b0803b456a54b8418"
  sensitive   = true
}

variable "mongo_uri" {
  description = "Connection string for the mongodb"
  default     = ""
  sensitive   = true
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

variable "azure_openai_api_deployment_name" {
  description = "(Optional) The deployment name of your Azure OpenAI API; if deployments.chat_model.name is defined, the default value is that value."
  default     = ""
}

variable "azure_openai_api_completions_deployment_name" {
  description = "(Optional) The deployment name for completion; if deployments.chat_model.name is defined, the default value is that value."
  default     = ""
}

variable "azure_openai_api_version" {
  description = "The version of your Azure OpenAI API"
  default     = "2023-05-15"
}

variable "azure_openai_api_embeddings_deployment_name" {
  description = "(Optional) The deployment name for embedding; if deployments.embedding_model.name is defined, the default value is that value."
  default     = ""
}

variable "azure_api_key" {
  type        = string
  description = "Azure API Key" # module.openai.openai_primary_key
}

variable "azure_openai_endpoint" {
  type        = string
  description = "Azure OpenAI Endpoint" # module.openai.openai_endpoint
}

variable "public_network_access_enabled" {
  description = "(Optional) Specifies whether public network access is allowed for the Azure OpenAI Service"
  type        = bool
  default     = false
}
