variable "application_gateways" {
  type = map(object({
    name                           = string                                # Required: Name of the Application Gateway
    resource_group_name            = string                                # Required: Resource group name
    location                       = string                                # Required: Azure region
    subnet_name                    = optional(string, null)                # Optional if subnet_id is provided: Subnet name
    vnet_name                      = optional(string, null)                # Optional if subnet_id is provided: Virtual network name
    subnet_id                      = optional(string, null)                # Optional: Subnet ID directly
    public_ip_name                 = optional(string, null)                # Optional if public_ip_id is provided: Public IP name
    public_ip_id                   = optional(string, null)                # Optional: Public IP ID directly
    sku_name                       = optional(string, "Standard_v2")       # Optional: SKU name (Standard_v2, WAF_v2)
    sku_tier                       = optional(string, "Standard_v2")       # Optional: SKU tier (Standard_v2, WAF_v2)
    capacity                       = optional(number, 2)                   # Optional: Static instance count
    autoscale_min_capacity         = optional(number, null)                # Optional: Autoscale min capacity
    autoscale_max_capacity         = optional(number, null)                # Optional: Autoscale max capacity
    gateway_ip_configuration_name  = optional(string, "appGwIpConfig")     # Optional: Gateway IP config name
    frontend_port_name             = optional(string, "appGwPort80")       # Optional: Frontend port name
    frontend_port                  = optional(number, 80)                  # Optional: Frontend port number
    frontend_ip_configuration_name = optional(string, "appGwPublicIp")     # Optional: Frontend IP config name
    backend_pool_name              = optional(string, "appGwBackendPool")  # Optional: Backend address pool name
    backend_pool_ip_addresses      = optional(list(string), [])            # Optional: Backend pool IP addresses
    backend_http_settings_name     = optional(string, "appGwBackendHttp")  # Optional: Backend HTTP settings name
    backend_port                   = optional(number, 80)                  # Optional: Backend port
    backend_protocol               = optional(string, "Http")              # Optional: Backend protocol (Http, Https)
    cookie_based_affinity          = optional(string, "Disabled")          # Optional: Cookie based affinity (Enabled/Disabled)
    request_timeout                = optional(number, 20)                  # Optional: Request timeout in seconds
    http_listener_name             = optional(string, "appGwHttpListener") # Optional: HTTP listener name
    http_listener_protocol         = optional(string, "Http")              # Optional: HTTP listener protocol (Http, Https)
    routing_rule_name              = optional(string, "appGwRoutingRule")  # Optional: Request routing rule name
    routing_rule_type              = optional(string, "Basic")             # Optional: Rule type (Basic, PathBasedRouting)
    routing_rule_priority          = optional(number, 100)                 # Optional: Rule priority (1-20000)
    tags                           = optional(map(string), {})             # Optional: Resource tags
  }))
  description = "Map of Azure Application Gateways to create with required and optional arguments."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional module-level default tags to merge with resource tags."
}
