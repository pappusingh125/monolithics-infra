variable "virtual_machines" {
  type = map(object({
    name                         = string                                           # Required: VM name
    resource_group_name          = string                                           # Required: Resource group name
    location                     = string                                           # Required: Azure region
    vnet_name                    = optional(string, null)                           # Optional if subnet_id is provided
    subnet_name                  = optional(string, null)                           # Optional if subnet_id is provided
    subnet_id                    = optional(string, null)                           # Optional: Subnet ID (if passing directly)
    size                         = optional(string, "Standard_B1s")                 # Optional: VM size (default Standard_B1s)
    zone                         = optional(string, null)                           # Optional: Availability zone
    admin_username               = optional(string, "azureuser")                    # Optional: Admin username
    admin_password               = optional(string, null)                           # Optional: Admin password directly
    key_vault_name               = optional(string, null)                           # Optional: Key vault name for secret lookup
    secret_name                  = optional(string, null)                           # Optional: Secret name in key vault
    public_ip_name               = optional(string, null)                           # Optional: Public IP name to associate
    public_ip_id                 = optional(string, null)                           # Optional: Public IP ID to associate directly
    os_disk_caching              = optional(string, "ReadWrite")                    # Optional: OS disk caching
    os_disk_storage_account_type = optional(string, "Standard_LRS")                 # Optional: OS disk storage account type
    os_disk_size_gb              = optional(number, null)                           # Optional: OS disk size in GB
    image_publisher              = optional(string, "Canonical")                    # Optional: Image publisher
    image_offer                  = optional(string, "0001-com-ubuntu-server-jammy") # Optional: Image offer
    image_sku                    = optional(string, "22_04-lts")                    # Optional: Image SKU
    image_version                = optional(string, "latest")                       # Optional: Image version
    custom_data                  = optional(string, null)                           # Optional: Base64-encoded cloud-init script
    data_disks = optional(map(object({                                              # Optional: Nested map of data disks
      name                 = string                                                 # Required for disk: Managed disk name
      disk_size_gb         = number                                                 # Required for disk: Size in GB
      lun                  = number                                                 # Required for disk: Logical Unit Number
      caching              = optional(string, "ReadWrite")                          # Optional: Caching
      storage_account_type = optional(string, "Standard_LRS")                       # Optional: Storage type
      create_option        = optional(string, "Empty")                              # Optional: Create option
    })), {})
    tags = optional(map(string), {}) # Optional: Resource tags
  }))
  description = "Map of Linux Virtual Machines to create with required and optional arguments, lifecycle, and nested data disks."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional module-level default tags to merge with resource tags."
}
