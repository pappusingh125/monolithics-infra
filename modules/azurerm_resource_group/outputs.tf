output "resource_groups" {
  value       = azurerm_resource_group.resource_group
  description = "Map of all resource group resources."
}

output "resource_group_ids" {
  value       = { for k, v in azurerm_resource_group.resource_group : k => v.id }
  description = "Map of Resource Group IDs."
}

output "resource_group_names" {
  value       = { for k, v in azurerm_resource_group.resource_group : k => v.name }
  description = "Map of Resource Group names."
}
