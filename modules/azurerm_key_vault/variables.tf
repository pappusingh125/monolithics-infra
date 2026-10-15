variable "key_vaults" {
  type = map(object({
    name                       = string                       # Required: Key Vault name (globally unique)
    resource_group_name        = string                       # Required: Resource group name
    location                   = string                       # Required: Azure region
    sku_name                   = optional(string, "standard") # Optional: SKU standard or premium
    soft_delete_retention_days = optional(number, 7)          # Optional: Soft delete retention days (7-90)
    purge_protection_enabled   = optional(bool, false)        # Optional: Purge protection enabled
    secret_name                = optional(string, null)       # Optional: Legacy/single secret name to auto-generate
    secrets = optional(map(object({                           # Optional: Nested map of secrets to create
      name     = string                                       # Required for secret: Secret name
      value    = optional(string, null)                       # Optional: Secret value (if null & generate=true, will auto-generate)
      generate = optional(bool, true)                         # Optional: Auto-generate random password
      length   = optional(number, 16)                         # Optional: Random password length
      special  = optional(bool, true)                         # Optional: Include special chars in password
    })), {})
    tags = optional(map(string), {}) # Optional: Resource tags
  }))
  description = "Map of Key Vaults to create with required and optional arguments, including optional nested secrets map."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional module-level default tags to merge with resource tags."
}
