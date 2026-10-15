locals {
  module_tags = {
    Module    = "azurerm_storage_account"
    ManagedBy = "Terraform"
  }

  # Flatten nested containers
  storage_containers = flatten([
    for sa_key, sa in var.storage_accounts : [
      for c_key, c in sa.containers : {
        key                   = "${sa_key}.${c_key}"
        sa_key                = sa_key
        name                  = c.name
        container_access_type = c.container_access_type
      }
    ]
  ])

  # Flatten nested blobs
  storage_blobs = flatten([
    for sa_key, sa in var.storage_accounts : [
      for b_key, b in sa.blobs : {
        key            = "${sa_key}.${b_key}"
        sa_key         = sa_key
        name           = b.name
        container_name = b.container_name
        type           = b.type
        source_file    = b.source_file
        content        = b.content
        content_type   = b.content_type
      }
    ]
  ])
}
