output "storage_accounts" {
  value       = azurerm_storage_account.sa
  description = "Map of all Storage Account resources."
}

output "storage_account_ids" {
  value       = { for k, v in azurerm_storage_account.sa : k => v.id }
  description = "Map of Storage Account IDs."
}

output "primary_blob_endpoints" {
  value       = { for k, v in azurerm_storage_account.sa : k => v.primary_blob_endpoint }
  description = "Map of primary blob endpoints."
}

output "container_ids" {
  value       = { for k, v in azurerm_storage_container.container : k => v.id }
  description = "Map of Storage Container IDs."
}

output "blob_urls" {
  value       = { for k, v in azurerm_storage_blob.blob : k => v.url }
  description = "Map of Storage Blob URLs."
}
