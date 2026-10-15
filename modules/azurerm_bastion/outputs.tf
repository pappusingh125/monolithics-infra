output "bastions" {
  value       = azurerm_bastion_host.bastion
  description = "Map of all Azure Bastion host resources."
}

output "bastion_ids" {
  value       = { for k, v in azurerm_bastion_host.bastion : k => v.id }
  description = "Map of Azure Bastion host IDs."
}

output "bastion_dns_names" {
  value       = { for k, v in azurerm_bastion_host.bastion : k => v.dns_name }
  description = "Map of Azure Bastion host DNS FQDNs."
}
