output "peerings" {
  value       = azurerm_virtual_network_peering.peering
  description = "Map of all Virtual Network Peering resources."
}

output "peering_ids" {
  value       = { for k, v in azurerm_virtual_network_peering.peering : k => v.id }
  description = "Map of Virtual Network Peering IDs."
}
