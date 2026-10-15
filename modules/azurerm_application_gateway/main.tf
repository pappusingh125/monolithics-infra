data "azurerm_subnet" "appgw_subnet" {
  for_each             = { for k, v in var.application_gateways : k => v if v.subnet_id == null && v.subnet_name != null && v.vnet_name != null }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "appgw_pip" {
  for_each            = { for k, v in var.application_gateways : k => v if v.public_ip_id == null && v.public_ip_name != null }
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_application_gateway" "appgw" {
  for_each            = var.application_gateways
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.autoscale_min_capacity == null ? each.value.capacity : null
  }

  dynamic "autoscale_configuration" {
    for_each = each.value.autoscale_min_capacity != null ? [1] : []
    content {
      min_capacity = each.value.autoscale_min_capacity
      max_capacity = each.value.autoscale_max_capacity
    }
  }

  gateway_ip_configuration {
    name      = each.value.gateway_ip_configuration_name
    subnet_id = each.value.subnet_id != null ? each.value.subnet_id : data.azurerm_subnet.appgw_subnet[each.key].id
  }

  frontend_port {
    name = each.value.frontend_port_name
    port = each.value.frontend_port
  }

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_configuration_name
    public_ip_address_id = each.value.public_ip_id != null ? each.value.public_ip_id : data.azurerm_public_ip.appgw_pip[each.key].id
  }

  backend_address_pool {
    name         = each.value.backend_pool_name
    ip_addresses = length(each.value.backend_pool_ip_addresses) > 0 ? each.value.backend_pool_ip_addresses : null
  }

  backend_http_settings {
    name                  = each.value.backend_http_settings_name
    cookie_based_affinity = each.value.cookie_based_affinity
    port                  = each.value.backend_port
    protocol              = each.value.backend_protocol
    request_timeout       = each.value.request_timeout
  }

  http_listener {
    name                           = each.value.http_listener_name
    frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
    frontend_port_name             = each.value.frontend_port_name
    protocol                       = each.value.http_listener_protocol
  }

  request_routing_rule {
    name                       = each.value.routing_rule_name
    priority                   = each.value.routing_rule_priority
    rule_type                  = each.value.routing_rule_type
    http_listener_name         = each.value.http_listener_name
    backend_address_pool_name  = each.value.backend_pool_name
    backend_http_settings_name = each.value.backend_http_settings_name
  }

  tags = merge(local.module_tags, var.tags, each.value.tags)

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }
}
