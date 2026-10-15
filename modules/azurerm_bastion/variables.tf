variable "bastions" {
  type = map(object({
    name                = string                                 # Required: Bastion Host name
    resource_group_name = string                                 # Required: Resource group name
    location            = string                                 # Required: Azure region
    vnet_name           = string                                 # Required: Virtual network name
    subnet_name         = optional(string, "AzureBastionSubnet") # Optional: Subnet name (must be AzureBastionSubnet)
    public_ip_name      = string                                 # Required: Public IP name
    sku                 = optional(string, "Basic")              # Optional: Basic or Standard SKU
    tags                = optional(map(string), {})              # Optional: Resource tags
  }))
  description = "Map of Azure Bastion hosts to create with required and optional arguments."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional module-level default tags to merge with resource tags."
}
