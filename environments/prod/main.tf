module "resource_group" {
  source          = "../../modules/azurerm_resource_group"
  resource_groups = var.resource_groups
  tags            = local.common_tags
}

module "virtual_network" {
  source           = "../../modules/azurerm_virtual_network"
  virtual_networks = var.virtual_networks
  tags             = local.common_tags
  depends_on       = [module.resource_group]
}

module "subnet" {
  source     = "../../modules/azurerm_subnet"
  subnets    = var.subnets
  depends_on = [module.virtual_network]
}

module "publicip" {
  source     = "../../modules/azurerm_public_ip"
  public_ips = var.public_ips
  tags       = local.common_tags
  depends_on = [module.resource_group]
}

module "key_vault" {
  source     = "../../modules/azurerm_key_vault"
  key_vaults = var.key_vaults
  tags       = local.common_tags
  depends_on = [module.resource_group]
}

module "storage_account" {
  source           = "../../modules/azurerm_storage_account"
  storage_accounts = var.storage_accounts
  tags             = local.common_tags
  depends_on       = [module.resource_group]
}

module "loadbalancer" {
  source         = "../../modules/azurerm_loadbalancer"
  load_balancers = var.load_balancers
  tags           = local.common_tags
  depends_on     = [module.subnet, module.publicip]
}

module "application_gateway" {
  source               = "../../modules/azurerm_application_gateway"
  application_gateways = var.application_gateways
  tags                 = local.common_tags
  depends_on           = [module.subnet, module.publicip]
}

module "virtual_machine" {
  source           = "../../modules/azurerm_virtual_machine"
  virtual_machines = var.virtual_machines
  tags             = local.common_tags
  depends_on       = [module.subnet, module.key_vault, module.publicip]
}

module "vnet_peering" {
  source        = "../../modules/azurerm_virtual_network_peering"
  vnet_peerings = var.vnet_peerings
  depends_on    = [module.virtual_network]
}

module "azuread_group" {
  source = "../../modules/azuread_group"
  groups = var.azuread_groups
}
