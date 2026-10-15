variable "groups" {
  type = map(object({
    display_name     = string                     # Required: Display name of the group
    description      = optional(string, null)     # Optional: Description of the group
    security_enabled = optional(bool, true)       # Optional: Is security group (default true)
    mail_enabled     = optional(bool, false)      # Optional: Is mail enabled (default false)
    members          = optional(list(string), []) # Optional: List of member object IDs to add to the group
    owners           = optional(list(string), []) # Optional: List of owner object IDs
  }))
  description = "Map of Azure AD / Entra ID Groups to create with user membership."
}
