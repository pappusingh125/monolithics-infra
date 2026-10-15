output "public_ips" {
  value       = azurerm_public_ip.publicip
  description = "Map of all public IP resources."
}

output "public_ip_ids" {
  value       = { for k, v in azurerm_public_ip.publicip : k => v.id }
  description = "Map of Public IP IDs."
}

output "public_ip_addresses" {
  value       = { for k, v in azurerm_public_ip.publicip : k => v.ip_address }
  description = "Map of Public IP addresses."
}
