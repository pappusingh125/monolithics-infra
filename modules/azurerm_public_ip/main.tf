resource "azurerm_public_ip" "publicip" {
  for_each = var.public_ips

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  zones               = each.value.zones
  tags                = merge(local.module_tags, var.tags, each.value.tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags["CreatedAt"]]
  }
}
