resource "azurerm_virtual_network" "virtual_network" {
  for_each = var.virtual_networks

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  dns_servers         = length(each.value.dns_servers) > 0 ? each.value.dns_servers : null
  tags                = merge(local.module_tags, var.tags, each.value.tags)

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }
}

# Optional nested subnets created directly with for_each
resource "azurerm_subnet" "nested_subnet" {
  for_each = { for snet in local.nested_subnets : snet.key => snet }

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network[each.value.vnet_key].name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints

  lifecycle {
    ignore_changes = [address_prefixes]
  }
}
