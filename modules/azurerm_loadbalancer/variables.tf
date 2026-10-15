variable "load_balancers" {
  type = map(object({
    name                = string                          # Required: Load Balancer name
    resource_group_name = string                          # Required: Resource group name
    location            = string                          # Required: Azure region
    sku                 = optional(string, "Standard")    # Optional: SKU (Standard or Basic)
    public_ip_name      = optional(string, null)          # Optional: Public IP name to look up
    public_ip_id        = optional(string, null)          # Optional: Public IP ID (if passing directly)
    vnet_name           = optional(string, null)          # Optional: Virtual network name for internal LB
    subnet_name         = optional(string, null)          # Optional: Subnet name for internal LB
    subnet_id           = optional(string, null)          # Optional: Subnet ID (if passing directly)
    frontend_ip_name    = optional(string, "FrontendIP")  # Optional: Frontend IP config name
    backend_pool_name   = optional(string, "BackendPool") # Optional: Backend address pool name
    probe_name          = optional(string, "HealthProbe") # Optional: Health probe name
    probe_port          = optional(number, 80)            # Optional: Health probe port
    probe_protocol      = optional(string, "Http")        # Optional: Health probe protocol (Http, Https, Tcp)
    probe_request_path  = optional(string, "/")           # Optional: Probe request path for HTTP/HTTPS
    lb_rule_name        = optional(string, "LBRule")      # Optional: Load balancing rule name
    frontend_port       = optional(number, 80)            # Optional: Frontend port
    backend_port        = optional(number, 80)            # Optional: Backend port
    protocol            = optional(string, "Tcp")         # Optional: Rule protocol (Tcp, Udp, All)
    tags                = optional(map(string), {})       # Optional: Resource tags
  }))
  description = "Map of Azure Load Balancers to create with required and optional arguments."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional module-level default tags to merge with resource tags."
}
