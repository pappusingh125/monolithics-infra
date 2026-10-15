variable "storage_accounts" {
  type = map(object({
    name                            = string                        # Required: Storage account name (3-24 alphanumeric lowercase)
    resource_group_name             = string                        # Required: Resource group name
    location                        = string                        # Required: Azure region
    account_tier                    = optional(string, "Standard")  # Optional: Standard or Premium
    account_replication_type        = optional(string, "LRS")       # Optional: LRS, GRS, ZRS, RAGRS
    account_kind                    = optional(string, "StorageV2") # Optional: StorageV2, BlobStorage, FileStorage
    min_tls_version                 = optional(string, "TLS1_2")    # Optional: TLS version
    enable_https_traffic_only       = optional(bool, true)          # Optional: Force HTTPS
    allow_nested_items_to_be_public = optional(bool, false)         # Optional: Public access allowed
    containers = optional(map(object({                              # Optional: Nested map of blob containers
      name                  = string                                # Required for container: Container name
      container_access_type = optional(string, "private")           # Optional: Access type (private, blob, container)
    })), {})
    blobs = optional(map(object({                     # Optional: Nested map of storage blobs
      name           = string                         # Required for blob: Blob name
      container_name = string                         # Required for blob: Target container name
      type           = optional(string, "Block")      # Optional: Type (Block, Append, Page)
      source_file    = optional(string, null)         # Optional: Path to local file
      content        = optional(string, null)         # Optional: String content of blob
      content_type   = optional(string, "text/plain") # Optional: MIME type
    })), {})
    tags = optional(map(string), {}) # Optional: Resource tags
  }))
  description = "Map of Storage Accounts with nested containers and blobs."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional module-level default tags to merge with resource tags."
}
