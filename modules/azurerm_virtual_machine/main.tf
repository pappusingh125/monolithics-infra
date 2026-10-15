data "azurerm_client_config" "current" {}

data "azurerm_subnet" "vm_subnet" {
  for_each             = { for k, v in var.virtual_machines : k => v if v.subnet_id == null && v.subnet_name != null && v.vnet_name != null }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_key_vault_secret" "password" {
  for_each     = { for k, v in var.virtual_machines : k => v if v.admin_password == null && v.key_vault_name != null && v.secret_name != null }
  name         = each.value.secret_name
  key_vault_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${each.value.resource_group_name}/providers/Microsoft.KeyVault/vaults/${each.value.key_vault_name}"
}

data "azurerm_public_ip" "vm_pip" {
  for_each            = { for k, v in var.virtual_machines : k => v if v.public_ip_name != null && v.public_ip_id == null }
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.virtual_machines
  name                = "${each.value.name}-nic"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = merge(local.module_tags, var.tags, each.value.tags)

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id != null ? each.value.subnet_id : data.azurerm_subnet.vm_subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.public_ip_id != null ? each.value.public_ip_id : (lookup(data.azurerm_public_ip.vm_pip, each.key, null) != null ? data.azurerm_public_ip.vm_pip[each.key].id : null)
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags["CreatedAt"]]
  }
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  for_each                        = var.virtual_machines
  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  zone                            = each.value.zone
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password != null ? each.value.admin_password : data.azurerm_key_vault_secret.password[each.key].value
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]
  custom_data                     = each.value.custom_data

  os_disk {
    caching              = each.value.os_disk_caching
    storage_account_type = each.value.os_disk_storage_account_type
    disk_size_gb         = each.value.os_disk_size_gb
  }

  source_image_reference {
    publisher = each.value.image_publisher
    offer     = each.value.image_offer
    sku       = each.value.image_sku
    version   = each.value.image_version
  }

  tags = merge(local.module_tags, var.tags, each.value.tags)

  lifecycle {
    ignore_changes = [
      admin_password,
      tags["CreatedAt"]
    ]
  }
}

# Optional nested managed data disks created with for_each
resource "azurerm_managed_disk" "data_disk" {
  for_each = { for d in local.vm_data_disks : d.key => d }

  name                 = each.value.name
  location             = each.value.location
  resource_group_name  = each.value.resource_group_name
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  tags                 = merge(local.module_tags, var.tags, each.value.tags)

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  for_each = { for d in local.vm_data_disks : d.key => d }

  managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.virtual_machine[each.value.vm_key].id
  lun                = each.value.lun
  caching            = each.value.caching
}
