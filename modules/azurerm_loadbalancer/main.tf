data "azurerm_public_ip" "lb_pip" {
  for_each            = { for k, v in var.load_balancers : k => v if v.public_ip_name != null && v.public_ip_id == null }
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_subnet" "lb_subnet" {
  for_each             = { for k, v in var.load_balancers : k => v if v.subnet_name != null && v.vnet_name != null && v.subnet_id == null }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

resource "azurerm_lb" "loadbalancer" {
  for_each            = var.load_balancers
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  tags                = merge(local.module_tags, var.tags, each.value.tags)

  frontend_ip_configuration {
    name                 = coalesce(each.value.frontend_ip_name, "FrontendIP")
    public_ip_address_id = each.value.public_ip_id != null ? each.value.public_ip_id : (lookup(data.azurerm_public_ip.lb_pip, each.key, null) != null ? data.azurerm_public_ip.lb_pip[each.key].id : null)
    subnet_id            = each.value.subnet_id != null ? each.value.subnet_id : (lookup(data.azurerm_subnet.lb_subnet, each.key, null) != null ? data.azurerm_subnet.lb_subnet[each.key].id : null)
  }

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }
}

resource "azurerm_lb_backend_address_pool" "pool" {
  for_each        = var.load_balancers
  name            = coalesce(each.value.backend_pool_name, "BackendPool")
  loadbalancer_id = azurerm_lb.loadbalancer[each.key].id
}

resource "azurerm_lb_probe" "probe" {
  for_each        = var.load_balancers
  name            = coalesce(each.value.probe_name, "HealthProbe")
  loadbalancer_id = azurerm_lb.loadbalancer[each.key].id
  port            = each.value.probe_port
  protocol        = each.value.probe_protocol
  request_path    = each.value.probe_protocol == "Http" || each.value.probe_protocol == "Https" ? each.value.probe_request_path : null
}

resource "azurerm_lb_rule" "rule" {
  for_each                       = var.load_balancers
  name                           = coalesce(each.value.lb_rule_name, "LBRule")
  loadbalancer_id                = azurerm_lb.loadbalancer[each.key].id
  frontend_ip_configuration_name = coalesce(each.value.frontend_ip_name, "FrontendIP")
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pool[each.key].id]
  probe_id                       = azurerm_lb_probe.probe[each.key].id
}
