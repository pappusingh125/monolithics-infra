output "groups" {
  value       = azuread_group.group
  description = "Map of all Azure AD group resources."
}

output "group_ids" {
  value       = { for k, v in azuread_group.group : k => v.id }
  description = "Map of Azure AD group IDs (Object IDs)."
}

output "group_display_names" {
  value       = { for k, v in azuread_group.group : k => v.display_name }
  description = "Map of Azure AD group display names."
}
