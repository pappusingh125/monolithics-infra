output "virtual_machines" {
  value       = azurerm_linux_virtual_machine.virtual_machine
  description = "Map of all Linux Virtual Machine resources."
}

output "vm_ids" {
  value       = { for k, v in azurerm_linux_virtual_machine.virtual_machine : k => v.id }
  description = "Map of Virtual Machine IDs."
}

output "nic_ids" {
  value       = { for k, v in azurerm_network_interface.nic : k => v.id }
  description = "Map of Network Interface IDs."
}

output "private_ip_addresses" {
  value       = { for k, v in azurerm_network_interface.nic : k => v.private_ip_address }
  description = "Map of private IP addresses allocated to the VMs."
}

output "data_disk_ids" {
  value       = { for k, v in azurerm_managed_disk.data_disk : k => v.id }
  description = "Map of Managed Data Disk IDs created from nested maps."
}
