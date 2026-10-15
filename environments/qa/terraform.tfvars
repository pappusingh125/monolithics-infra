tags = {
  Environment = "QA"
  ManagedBy   = "Terraform"
  Project     = "PPS-Monolithics"
}

resource_groups = {
  rg_qa = {
    name     = "rg-pps-qa"
    location = "eastus2"
    tags = {
      Environment = "QA"
      Tier        = "Web-DB"
    }
  }
}

virtual_networks = {
  vnet_qa = {
    name                = "vnet-pps-qa"
    resource_group_name = "rg-pps-qa"
    location            = "eastus2"
    address_space       = ["10.20.0.0/16"]
    tags = {
      Role = "QA-VNet"
    }
  }
}

subnets = {
  subnet_vm = {
    name                 = "snet-pps-qa-vm"
    resource_group_name  = "rg-pps-qa"
    virtual_network_name = "vnet-pps-qa"
    address_prefixes     = ["10.20.1.0/24"]
  }
  subnet_bastion = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "rg-pps-qa"
    virtual_network_name = "vnet-pps-qa"
    address_prefixes     = ["10.20.2.0/27"]
  }
  subnet_lb = {
    name                 = "snet-pps-qa-lb"
    resource_group_name  = "rg-pps-qa"
    virtual_network_name = "vnet-pps-qa"
    address_prefixes     = ["10.20.3.0/24"]
  }
  subnet_appgw = {
    name                 = "snet-pps-qa-appgw"
    resource_group_name  = "rg-pps-qa"
    virtual_network_name = "vnet-pps-qa"
    address_prefixes     = ["10.20.4.0/24"]
  }
}

public_ips = {
  pip_bastion = {
    name                = "pip-pps-qa-bastion"
    resource_group_name = "rg-pps-qa"
    location            = "eastus2"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
  pip_lb = {
    name                = "pip-pps-qa-lb"
    resource_group_name = "rg-pps-qa"
    location            = "eastus2"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
  pip_appgw = {
    name                = "pip-pps-qa-appgw"
    resource_group_name = "rg-pps-qa"
    location            = "eastus2"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
}

key_vaults = {
  kv_qa = {
    name                       = "kv-pps-qa"
    resource_group_name        = "rg-pps-qa"
    location                   = "eastus2"
    sku_name                   = "standard"
    soft_delete_retention_days = 7
    purge_protection_enabled   = false
    secret_name                = "secret-pps-qa-vmpass"
    secrets = {
      db_pass = {
        name     = "secret-pps-qa-dbpass"
        generate = true
        length   = 16
        special  = true
      }
    }
  }
}

storage_accounts = {
  sa_qa = {
    name                     = "stppsqa01"
    resource_group_name      = "rg-pps-qa"
    location                 = "eastus2"
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
        content        = "Welcome to PPS QA Storage Blob"
      }
    }
  }
}

bastions = {
  bastion_qa = {
    name                = "bas-pps-qa"
    resource_group_name = "rg-pps-qa"
    location            = "eastus2"
    vnet_name           = "vnet-pps-qa"
    subnet_name         = "AzureBastionSubnet"
    public_ip_name      = "pip-pps-qa-bastion"
    sku                 = "Basic"
  }
}

load_balancers = {
  lb_qa = {
    name                = "lb-pps-qa"
    resource_group_name = "rg-pps-qa"
    location            = "eastus2"
    sku                 = "Standard"
    public_ip_name      = "pip-pps-qa-lb"
    frontend_ip_name    = "pip-pps-qa-frontend"
    backend_pool_name   = "bap-pps-qa-backend"
    probe_name          = "hp-pps-qa-http"
    probe_port          = 80
    probe_protocol      = "Http"
    probe_request_path  = "/"
    lb_rule_name        = "lbr-pps-qa-http"
    frontend_port       = 80
    backend_port        = 80
    protocol            = "Tcp"
  }
}

application_gateways = {
  appgw_qa = {
    name                           = "agw-pps-qa"
    resource_group_name            = "rg-pps-qa"
    location                       = "eastus2"
    vnet_name                      = "vnet-pps-qa"
    subnet_name                    = "snet-pps-qa-appgw"
    public_ip_name                 = "pip-pps-qa-appgw"
    sku_name                       = "Standard_v2"
    sku_tier                       = "Standard_v2"
    capacity                       = 1
    gateway_ip_configuration_name  = "agw-pps-qa-ipconfig"
    frontend_port_name             = "agw-pps-qa-feport-80"
    frontend_port                  = 80
    frontend_ip_configuration_name = "agw-pps-qa-feip"
    backend_pool_name              = "agw-pps-qa-backendpool"
    backend_http_settings_name     = "agw-pps-qa-httpsettings"
    backend_port                   = 80
    backend_protocol               = "Http"
    cookie_based_affinity          = "Disabled"
    request_timeout                = 30
    http_listener_name             = "agw-pps-qa-httplistener"
    http_listener_protocol         = "Http"
    routing_rule_name              = "agw-pps-qa-routingrule"
    routing_rule_type              = "Basic"
    routing_rule_priority          = 100
  }
}

virtual_machines = {
  vm_qa = {
    name                         = "vm-pps-qa"
    resource_group_name          = "rg-pps-qa"
    location                     = "eastus2"
    size                         = "Standard_B1s"
    zone                         = null
    admin_username               = "qaadmin"
    vnet_name                    = "vnet-pps-qa"
    subnet_name                  = "snet-pps-qa-vm"
    public_ip_name               = null
    key_vault_name               = "kv-pps-qa"
    secret_name                  = "secret-pps-qa-vmpass"
    os_disk_caching              = "ReadWrite"
    os_disk_storage_account_type = "Standard_LRS"
    image_publisher              = "Canonical"
    image_offer                  = "0001-com-ubuntu-server-jammy"
    image_sku                    = "22_04-lts"
    image_version                = "latest"
  }
}

vnet_peerings = {
  qa_to_prod = {
    name                         = "peer-qa-to-prod"
    resource_group_name          = "rg-pps-qa"
    virtual_network_name         = "vnet-pps-qa"
    remote_virtual_network_name  = "vnet-pps-prod"
    remote_resource_group_name   = "rg-pps-prod"
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
