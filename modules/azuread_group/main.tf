resource "azuread_group" "group" {
  for_each = var.groups

  display_name     = each.value.display_name
  description      = each.value.description
  security_enabled = each.value.security_enabled
  mail_enabled     = each.value.mail_enabled
  members          = length(each.value.members) > 0 ? each.value.members : null
  owners           = length(each.value.owners) > 0 ? each.value.owners : null

  lifecycle {
    ignore_changes = [owners]
  }
}
