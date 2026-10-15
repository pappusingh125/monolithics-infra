locals {
  module_tags = {
    Module    = "azurerm_virtual_machine"
    ManagedBy = "Terraform"
  }

  # Flatten nested data disks map
  vm_data_disks = flatten([
    for vm_key, vm in var.virtual_machines : [
      for disk_key, disk in vm.data_disks : {
        key                  = "${vm_key}.${disk_key}"
        vm_key               = vm_key
        name                 = disk.name
        resource_group_name  = vm.resource_group_name
        location             = vm.location
        disk_size_gb         = disk.disk_size_gb
        lun                  = disk.lun
        caching              = disk.caching
        storage_account_type = disk.storage_account_type
        create_option        = disk.create_option
        tags                 = vm.tags
      }
    ]
  ])
}
