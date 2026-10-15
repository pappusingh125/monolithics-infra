data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each = var.key_vaults

  name                       = each.value.name
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = each.value.sku_name
  soft_delete_retention_days = each.value.soft_delete_retention_days
  purge_protection_enabled   = each.value.purge_protection_enabled

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
      "Recover"
    ]
  }

  tags = merge(local.module_tags, var.tags, each.value.tags)

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags["CreatedAt"]]
  }
}

resource "random_password" "password" {
  for_each = {
    for s in local.all_secrets : s.key => s if s.generate && s.value == null
  }

  length           = each.value.length
  special          = each.value.special
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = {
    for s in local.all_secrets : s.key => s
  }

  name         = each.value.name
  value        = each.value.value != null ? each.value.value : random_password.password[each.key].result
  key_vault_id = azurerm_key_vault.kv[each.value.kv_key].id

  lifecycle {
    ignore_changes = [value, tags["CreatedAt"]]
  }
}
