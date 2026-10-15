variable "vnet_peerings" {
  type = map(object({
    name                         = string                # Required: Peering name
    resource_group_name          = string                # Required: Local VNet resource group name
    virtual_network_name         = string                # Required: Local VNet name
    remote_virtual_network_name  = string                # Required: Remote VNet name
    remote_resource_group_name   = string                # Required: Remote VNet resource group name
    allow_virtual_network_access = optional(bool, true)  # Optional: Allow access from remote to local
    allow_forwarded_traffic      = optional(bool, false) # Optional: Allow forwarded traffic
    allow_gateway_transit        = optional(bool, false) # Optional: Allow gateway transit
    use_remote_gateways          = optional(bool, false) # Optional: Use remote gateways
  }))
  default     = {}
  description = "Map of Virtual Network Peerings with required and optional arguments."
}
