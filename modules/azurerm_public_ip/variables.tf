variable "public_ips" {
  type = map(object({
    name                = string                       # Required: Public IP name
    resource_group_name = string                       # Required: Resource group name
    location            = string                       # Required: Azure region
    allocation_method   = optional(string, "Static")   # Optional: Static or Dynamic (defaults to Static)
    sku                 = optional(string, "Standard") # Optional: Basic or Standard (defaults to Standard)
    zones               = optional(list(string), null) # Optional: Availability zones
    tags                = optional(map(string), {})    # Optional: Resource tags
  }))
  description = "Map of Public IPs to create with required and optional arguments."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional module-level default tags to merge with resource tags."
}
