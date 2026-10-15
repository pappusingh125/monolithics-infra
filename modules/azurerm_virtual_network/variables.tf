variable "virtual_networks" {
  type = map(object({
    name                = string                     # Required: Name of the virtual network
    resource_group_name = string                     # Required: Target resource group name
    location            = string                     # Required: Azure region
    address_space       = list(string)               # Required: List of CIDR address prefixes
    dns_servers         = optional(list(string), []) # Optional: Custom DNS servers list
    subnets = optional(map(object({
      name              = string                     # Required for nested subnet: Subnet name
      address_prefixes  = list(string)               # Required for nested subnet: Subnet CIDR list
      service_endpoints = optional(list(string), []) # Optional: Service endpoints
    })), {})
    tags = optional(map(string), {}) # Optional: Resource-specific tags
  }))
  description = "Map of Virtual Networks to create with required and optional arguments (including optional nested subnets map)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional module-level default tags to merge with resource tags."
}
