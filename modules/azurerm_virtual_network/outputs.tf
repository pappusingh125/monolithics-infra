output "virtual_networks" {
  value       = azurerm_virtual_network.virtual_network
  description = "Map of all virtual network resources."
}

output "virtual_network_ids" {
  value       = { for k, v in azurerm_virtual_network.virtual_network : k => v.id }
  description = "Map of Virtual Network IDs."
}

output "virtual_network_names" {
  value       = { for k, v in azurerm_virtual_network.virtual_network : k => v.name }
  description = "Map of Virtual Network names."
}

output "nested_subnet_ids" {
  value       = { for k, v in azurerm_subnet.nested_subnet : k => v.id }
  description = "Map of nested Subnet IDs created with the virtual network."
}
