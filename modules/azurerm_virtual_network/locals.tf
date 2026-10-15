locals {
  module_tags = {
    Module    = "azurerm_virtual_network"
    ManagedBy = "Terraform"
  }

  # Flatten nested subnets map for for_each iteration
  nested_subnets = flatten([
    for vnet_key, vnet in var.virtual_networks : [
      for snet_key, snet in vnet.subnets : {
        key                  = "${vnet_key}.${snet_key}"
        name                 = snet.name
        resource_group_name  = vnet.resource_group_name
        virtual_network_name = vnet.name
        vnet_key             = vnet_key
        address_prefixes     = snet.address_prefixes
        service_endpoints    = snet.service_endpoints
      }
    ]
  ])
}
