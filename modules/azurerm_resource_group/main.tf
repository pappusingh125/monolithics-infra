resource "azurerm_resource_group" "resource_group" {
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
  tags     = merge(local.module_tags, var.tags, each.value.tags)

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags["CreatedAt"]]
  }
}
