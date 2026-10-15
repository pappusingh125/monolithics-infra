resource "azurerm_storage_account" "sa" {
  for_each = var.storage_accounts

  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  account_tier                    = each.value.account_tier
  account_replication_type        = each.value.account_replication_type
  account_kind                    = each.value.account_kind
  min_tls_version                 = each.value.min_tls_version
  enable_https_traffic_only       = each.value.enable_https_traffic_only
  allow_nested_items_to_be_public = each.value.allow_nested_items_to_be_public
  tags                            = merge(local.module_tags, var.tags, each.value.tags)

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags["CreatedAt"]]
  }
}

resource "azurerm_storage_container" "container" {
  for_each = {
    for c in local.storage_containers : c.key => c
  }

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.sa[each.value.sa_key].name
  container_access_type = each.value.container_access_type
}

resource "azurerm_storage_blob" "blob" {
  for_each = {
    for b in local.storage_blobs : b.key => b
  }

  name                   = each.value.name
  storage_account_name   = azurerm_storage_account.sa[each.value.sa_key].name
  storage_container_name = each.value.container_name
  type                   = each.value.type
  source                 = each.value.source_file
  source_content         = each.value.content
  content_type           = each.value.content_type
  depends_on             = [azurerm_storage_container.container]
}
