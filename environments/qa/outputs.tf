output "resource_group_names" {
  value       = module.resource_group.resource_group_names
  description = "Resource Group names created in qa."
}

output "virtual_network_ids" {
  value       = module.virtual_network.virtual_network_ids
  description = "Virtual Network IDs created in qa."
}

output "subnet_ids" {
  value       = module.subnet.subnet_ids
  description = "Subnet IDs created in qa."
}

output "public_ip_addresses" {
  value       = module.publicip.public_ip_addresses
  description = "Public IP addresses created in qa."
}

output "key_vault_uris" {
  value       = module.key_vault.key_vault_uris
  description = "Key Vault URIs created in qa."
}

output "storage_account_ids" {
  value       = module.storage_account.storage_account_ids
  description = "Storage Account IDs created in qa."
}

output "primary_blob_endpoints" {
  value       = module.storage_account.primary_blob_endpoints
  description = "Primary Blob Endpoints created in qa."
}

output "bastion_ids" {
  value       = module.bastion.bastion_ids
  description = "Azure Bastion IDs created in qa."
}

output "load_balancer_ids" {
  value       = module.loadbalancer.load_balancer_ids
  description = "Load Balancer IDs created in qa."
}

output "application_gateway_ids" {
  value       = module.application_gateway.application_gateway_ids
  description = "Application Gateway IDs created in qa."
}

output "azuread_group_ids" {
  value       = module.azuread_group.group_ids
  description = "Azure AD Group Object IDs created in qa."
}

output "vm_ids" {
  value       = module.virtual_machine.vm_ids
  description = "Virtual Machine IDs created in qa."
}

output "vm_private_ip_addresses" {
  value       = module.virtual_machine.private_ip_addresses
  description = "Virtual Machine private IP addresses in qa."
}
