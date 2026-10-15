locals {
  module_tags = {
    Module    = "azurerm_key_vault"
    ManagedBy = "Terraform"
  }

  # Flatten secrets from nested map and support legacy secret_name
  all_secrets = flatten([
    for kv_key, kv in var.key_vaults : concat(
      # If secret_name is specified at key vault root, include it
      kv.secret_name != null ? [{
        key      = "${kv_key}.default_secret"
        kv_key   = kv_key
        name     = kv.secret_name
        value    = null
        generate = true
        length   = 16
        special  = true
      }] : [],
      # Nested map secrets
      [
        for sec_key, sec in kv.secrets : {
          key      = "${kv_key}.${sec_key}"
          kv_key   = kv_key
          name     = sec.name
          value    = sec.value
          generate = sec.generate
          length   = sec.length
          special  = sec.special
        }
      ]
    )
  ])
}
