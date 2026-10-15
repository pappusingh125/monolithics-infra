variable "resource_groups" {
  type = map(object({
    name     = string                    # Required argument: Name of the resource group
    location = string                    # Required argument: Azure region
    tags     = optional(map(string), {}) # Optional argument: Resource-specific tags
  }))
  description = "Map of Resource Groups to create with required and optional arguments."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional module-level default tags to merge with resource tags."
}
