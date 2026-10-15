output "key_vaults" {
  value       = azurerm_key_vault.kv
  description = "Map of all key vault resources."
}

output "key_vault_ids" {
  value       = { for k, v in azurerm_key_vault.kv : k => v.id }
  description = "Map of Key Vault IDs."
}

output "key_vault_uris" {
  value       = { for k, v in azurerm_key_vault.kv : k => v.vault_uri }
  description = "Map of Key Vault URIs."
}

output "secret_ids" {
  value       = { for k, v in azurerm_key_vault_secret.secret : k => v.id }
  description = "Map of Key Vault Secret IDs."
}

output "secret_values" {
  value       = { for k, v in azurerm_key_vault_secret.secret : k => v.value }
  sensitive   = true
  description = "Map of Key Vault Secret values."
}
