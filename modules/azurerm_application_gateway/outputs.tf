output "application_gateways" {
  value       = azurerm_application_gateway.appgw
  description = "Map of all Azure Application Gateway resources."
}

output "application_gateway_ids" {
  value       = { for k, v in azurerm_application_gateway.appgw : k => v.id }
  description = "Map of Azure Application Gateway IDs."
}

output "application_gateway_names" {
  value       = { for k, v in azurerm_application_gateway.appgw : k => v.name }
  description = "Map of Azure Application Gateway names."
}

output "backend_address_pool_ids" {
  value       = { for k, v in azurerm_application_gateway.appgw : k => v.backend_address_pool[*].id }
  description = "Map of backend address pool IDs."
}
