tags = {
  Environment = "Prod"
  ManagedBy   = "Terraform"
  Project     = "PPS-Monolithics"
}

resource_groups = {
  rg_prod = {
    name     = "rg-pps-prod"
    location = "eastus"
    tags = {
      Environment = "Prod"
      Tier        = "Web-DB"
    }
  }
}

virtual_networks = {
  vnet_prod = {
    name                = "vnet-pps-prod"
    resource_group_name = "rg-pps-prod"
    location            = "eastus"
    address_space       = ["10.30.0.0/16"]
    tags = {
      Role = "Production-VNet"
    }
  }
}

subnets = {
  subnet_vm = {
    name                 = "snet-pps-prod-vm"
    resource_group_name  = "rg-pps-prod"
    virtual_network_name = "vnet-pps-prod"
    address_prefixes     = ["10.30.1.0/24"]
  }
  subnet_lb = {
    name                 = "snet-pps-prod-lb"
    resource_group_name  = "rg-pps-prod"
    virtual_network_name = "vnet-pps-prod"
    address_prefixes     = ["10.30.2.0/24"]
  }
  subnet_appgw = {
    name                 = "snet-pps-prod-appgw"
    resource_group_name  = "rg-pps-prod"
    virtual_network_name = "vnet-pps-prod"
    address_prefixes     = ["10.30.3.0/24"]
  }
}

public_ips = {
  pip_vm = {
    name                = "pip-pps-prod-vm"
    resource_group_name = "rg-pps-prod"
    location            = "eastus"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
  pip_lb = {
    name                = "pip-pps-prod-lb"
    resource_group_name = "rg-pps-prod"
    location            = "eastus"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
  pip_appgw = {
    name                = "pip-pps-prod-appgw"
    resource_group_name = "rg-pps-prod"
    location            = "eastus"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
}

key_vaults = {
  kv_prod = {
    name                       = "kv-pps-prod"
    resource_group_name        = "rg-pps-prod"
    location                   = "eastus"
    sku_name                   = "standard"
    soft_delete_retention_days = 7
    purge_protection_enabled   = false
    secret_name                = "secret-pps-prod-vmpass"
    secrets = {
      db_pass = {
        name     = "secret-pps-prod-dbpass"
        generate = true
        length   = 20
        special  = true
      }
    }
  }
}

storage_accounts = {
  sa_prod = {
    name                     = "stppsprod01"
    resource_group_name      = "rg-pps-prod"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    containers = {
      blobcontainer01 = {
        name                  = "blobcontainer01"
        container_access_type = "private"
      }
    }
    blobs = {
      welcome_blob = {
        name           = "welcome.txt"
        container_name = "blobcontainer01"
        type           = "Block"
        content        = "Welcome to PPS Production Storage Blob"
      }
    }
  }
}

load_balancers = {
  lb_prod = {
    name                = "lb-pps-prod"
    resource_group_name = "rg-pps-prod"
    location            = "eastus"
    sku                 = "Standard"
    public_ip_name      = "pip-pps-prod-lb"
    frontend_ip_name    = "pip-pps-prod-frontend"
    backend_pool_name   = "bap-pps-prod-backend"
    probe_name          = "hp-pps-prod-http"
    probe_port          = 80
    probe_protocol      = "Http"
    probe_request_path  = "/"
    lb_rule_name        = "lbr-pps-prod-http"
    frontend_port       = 80
    backend_port        = 80
    protocol            = "Tcp"
  }
}

application_gateways = {
  appgw_prod = {
    name                           = "agw-pps-prod"
    resource_group_name            = "rg-pps-prod"
    location                       = "eastus"
    vnet_name                      = "vnet-pps-prod"
    subnet_name                    = "snet-pps-prod-appgw"
    public_ip_name                 = "pip-pps-prod-appgw"
    sku_name                       = "Standard_v2"
    sku_tier                       = "Standard_v2"
    capacity                       = 2
    gateway_ip_configuration_name  = "agw-pps-prod-ipconfig"
    frontend_port_name             = "agw-pps-prod-feport-80"
    frontend_port                  = 80
    frontend_ip_configuration_name = "agw-pps-prod-feip"
    backend_pool_name              = "agw-pps-prod-backendpool"
    backend_http_settings_name     = "agw-pps-prod-httpsettings"
    backend_port                   = 80
    backend_protocol               = "Http"
    cookie_based_affinity          = "Disabled"
    request_timeout                = 30
    http_listener_name             = "agw-pps-prod-httplistener"
    http_listener_protocol         = "Http"
    routing_rule_name              = "agw-pps-prod-routingrule"
    routing_rule_type              = "Basic"
    routing_rule_priority          = 100
  }
}

virtual_machines = {
  vm_prod = {
    name                         = "vm-pps-prod"
    resource_group_name          = "rg-pps-prod"
    location                     = "eastus"
    size                         = "Standard_F2s_v2"
    zone                         = null
    admin_username               = "prodadmin"
    vnet_name                    = "vnet-pps-prod"
    subnet_name                  = "snet-pps-prod-vm"
    public_ip_name               = "pip-pps-prod-vm"
    key_vault_name               = "kv-pps-prod"
    secret_name                  = "secret-pps-prod-vmpass"
    os_disk_caching              = "ReadWrite"
    os_disk_storage_account_type = "Standard_LRS"
    image_publisher              = "Canonical"
    image_offer                  = "0001-com-ubuntu-server-jammy"
    image_sku                    = "22_04-lts"
    image_version                = "latest"
  }
}

vnet_peerings = {
  prod_to_qa = {
    name                         = "peer-prod-to-qa"
    resource_group_name          = "rg-pps-prod"
    virtual_network_name         = "vnet-pps-prod"
    remote_virtual_network_name  = "vnet-pps-qa"
    remote_resource_group_name   = "rg-pps-qa"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }
}

azuread_groups = {
  pps_reader = {
    display_name     = "pps_reader"
    description      = "Reader access group for PPS resources"
    security_enabled = true
    members          = []
  }
  pps_contributor = {
    display_name     = "pps_contributor"
    description      = "Contributor access group for PPS resources"
    security_enabled = true
    members          = []
  }
  pps_pim = {
    display_name     = "pps_pim"
    description      = "Privileged Identity Management group for PPS"
    security_enabled = true
    members          = []
  }
}
