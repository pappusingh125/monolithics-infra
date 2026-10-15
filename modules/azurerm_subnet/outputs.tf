output "subnets" {
  value       = azurerm_subnet.subnet
  description = "Map of all subnet resources."
}

output "subnet_ids" {
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
  description = "Map of Subnet IDs."
}

output "subnet_names" {
  value       = { for k, v in azurerm_subnet.subnet : k => v.name }
  description = "Map of Subnet names."
}
