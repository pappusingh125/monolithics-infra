output "load_balancers" {
  value       = azurerm_lb.loadbalancer
  description = "Map of all Load Balancer resources."
}

output "load_balancer_ids" {
  value       = { for k, v in azurerm_lb.loadbalancer : k => v.id }
  description = "Map of Load Balancer IDs."
}

output "frontend_ip_configurations" {
  value       = { for k, v in azurerm_lb.loadbalancer : k => v.frontend_ip_configuration }
  description = "Map of Load Balancer frontend IP configurations."
}

output "backend_pool_ids" {
  value       = { for k, v in azurerm_lb_backend_address_pool.pool : k => v.id }
  description = "Map of Load Balancer backend address pool IDs."
}

output "probe_ids" {
  value       = { for k, v in azurerm_lb_probe.probe : k => v.id }
  description = "Map of Load Balancer health probe IDs."
}

output "rule_ids" {
  value       = { for k, v in azurerm_lb_rule.rule : k => v.id }
  description = "Map of Load Balancer rule IDs."
}
