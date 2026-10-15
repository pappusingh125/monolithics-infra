variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional common tags across prod environment."
}

variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  }))
  description = "Map of Resource Groups to create in prod."
}

variable "virtual_networks" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    dns_servers         = optional(list(string), [])
    subnets = optional(map(object({
      name              = string
      address_prefixes  = list(string)
      service_endpoints = optional(list(string), [])
    })), {})
    tags = optional(map(string), {})
  }))
  description = "Map of Virtual Networks to create in prod."
}

variable "subnets" {
  type = map(object({
    name                                      = string
    resource_group_name                       = string
    virtual_network_name                      = string
    address_prefixes                          = list(string)
    service_endpoints                         = optional(list(string), [])
    private_endpoint_network_policies_enabled = optional(bool, true)
  }))
  default     = {}
  description = "Map of independent Subnets to create in prod."
}

variable "public_ips" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    allocation_method   = optional(string, "Static")
    sku                 = optional(string, "Standard")
    zones               = optional(list(string), null)
    tags                = optional(map(string), {})
  }))
  default     = {}
  description = "Map of Public IPs to create in prod."
}

variable "key_vaults" {
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    sku_name                   = optional(string, "standard")
    soft_delete_retention_days = optional(number, 7)
    purge_protection_enabled   = optional(bool, false)
    secret_name                = optional(string, null)
    secrets = optional(map(object({
      name     = string
      value    = optional(string, null)
      generate = optional(bool, true)
      length   = optional(number, 16)
      special  = optional(bool, true)
    })), {})
    tags = optional(map(string), {})
  }))
  description = "Map of Key Vaults to create in prod with auto-generated secrets."
}

variable "load_balancers" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = optional(string, "Standard")
    public_ip_name      = optional(string, null)
    public_ip_id        = optional(string, null)
    vnet_name           = optional(string, null)
    subnet_name         = optional(string, null)
    subnet_id           = optional(string, null)
    frontend_ip_name    = optional(string, "FrontendIP")
    backend_pool_name   = optional(string, "BackendPool")
    probe_name          = optional(string, "HealthProbe")
    probe_port          = optional(number, 80)
    probe_protocol      = optional(string, "Http")
    probe_request_path  = optional(string, "/")
    lb_rule_name        = optional(string, "LBRule")
    frontend_port       = optional(number, 80)
    backend_port        = optional(number, 80)
    protocol            = optional(string, "Tcp")
    tags                = optional(map(string), {})
  }))
  default     = {}
  description = "Map of Load Balancers to create in prod."
}

variable "virtual_machines" {
  type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    vnet_name                    = optional(string, null)
    subnet_name                  = optional(string, null)
    subnet_id                    = optional(string, null)
    size                         = optional(string, "Standard_B1s")
    zone                         = optional(string, null)
    admin_username               = optional(string, "azureuser")
    admin_password               = optional(string, null)
    key_vault_name               = optional(string, null)
    secret_name                  = optional(string, null)
    public_ip_name               = optional(string, null)
    public_ip_id                 = optional(string, null)
    os_disk_caching              = optional(string, "ReadWrite")
    os_disk_storage_account_type = optional(string, "Standard_LRS")
    os_disk_size_gb              = optional(number, null)
    image_publisher              = optional(string, "Canonical")
    image_offer                  = optional(string, "0001-com-ubuntu-server-jammy")
    image_sku                    = optional(string, "22_04-lts")
    image_version                = optional(string, "latest")
    custom_data                  = optional(string, null)
    data_disks = optional(map(object({
      name                 = string
      disk_size_gb         = number
      lun                  = number
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "Standard_LRS")
      create_option        = optional(string, "Empty")
    })), {})
    tags = optional(map(string), {})
  }))
  description = "Map of Linux Virtual Machines to create in prod."
}

variable "vnet_peerings" {
  type = map(object({
    name                         = string
    resource_group_name          = string
    virtual_network_name         = string
    remote_virtual_network_name  = string
    remote_resource_group_name   = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  default     = {}
  description = "Map of Virtual Network Peerings in prod."
}

variable "application_gateways" {
  type = map(object({
    name                           = string
    resource_group_name            = string
    location                       = string
    subnet_name                    = optional(string, null)
    vnet_name                      = optional(string, null)
    subnet_id                      = optional(string, null)
    public_ip_name                 = optional(string, null)
    public_ip_id                   = optional(string, null)
    sku_name                       = optional(string, "Standard_v2")
    sku_tier                       = optional(string, "Standard_v2")
    capacity                       = optional(number, 2)
    autoscale_min_capacity         = optional(number, null)
    autoscale_max_capacity         = optional(number, null)
    gateway_ip_configuration_name  = optional(string, "appGwIpConfig")
    frontend_port_name             = optional(string, "appGwPort80")
    frontend_port                  = optional(number, 80)
    frontend_ip_configuration_name = optional(string, "appGwPublicIp")
    backend_pool_name              = optional(string, "appGwBackendPool")
    backend_pool_ip_addresses      = optional(list(string), [])
    backend_http_settings_name     = optional(string, "appGwBackendHttp")
    backend_port                   = optional(number, 80)
    backend_protocol               = optional(string, "Http")
    cookie_based_affinity          = optional(string, "Disabled")
    request_timeout                = optional(number, 20)
    http_listener_name             = optional(string, "appGwHttpListener")
    http_listener_protocol         = optional(string, "Http")
    routing_rule_name              = optional(string, "appGwRoutingRule")
    routing_rule_type              = optional(string, "Basic")
    routing_rule_priority          = optional(number, 100)
    tags                           = optional(map(string), {})
  }))
  default     = {}
  description = "Map of Application Gateways to create in prod."
}

variable "storage_accounts" {
  type = map(object({
    name                            = string
    resource_group_name             = string
    location                        = string
    account_tier                    = optional(string, "Standard")
    account_replication_type        = optional(string, "LRS")
    account_kind                    = optional(string, "StorageV2")
    min_tls_version                 = optional(string, "TLS1_2")
    enable_https_traffic_only       = optional(bool, true)
    allow_nested_items_to_be_public = optional(bool, false)
    containers = optional(map(object({
      name                  = string
      container_access_type = optional(string, "private")
    })), {})
    blobs = optional(map(object({
      name           = string
      container_name = string
      type           = optional(string, "Block")
      source_file    = optional(string, null)
      content        = optional(string, null)
      content_type   = optional(string, "text/plain")
    })), {})
    tags = optional(map(string), {})
  }))
  default     = {}
  description = "Map of Storage Accounts with containers and blobs in prod."
}

variable "azuread_groups" {
  type = map(object({
    display_name     = string
    description      = optional(string, null)
    security_enabled = optional(bool, true)
    mail_enabled     = optional(bool, false)
    members          = optional(list(string), [])
    owners           = optional(list(string), [])
  }))
  default     = {}
  description = "Map of Azure AD / Entra ID Groups to create in prod."
}


