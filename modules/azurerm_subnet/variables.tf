variable "subnets" {
  type = map(object({
    name                                      = string                     # Required: Name of the subnet
    resource_group_name                       = string                     # Required: Resource group name
    virtual_network_name                      = string                     # Required: Virtual network name
    address_prefixes                          = list(string)               # Required: List of address prefixes for subnet
    service_endpoints                         = optional(list(string), []) # Optional: Service endpoints
    private_endpoint_network_policies_enabled = optional(bool, true)       # Optional: Enable private endpoint network policies
  }))
  description = "Map of Subnets to create with required and optional arguments."
}
