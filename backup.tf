locals {
  postfix                            = "-rsv"
  maxLenght                          = 50 
  env_4_bk                              = substr(var.env, 0, 4)
  regex                              = "/[^0-9A-Za-z-]/"
  userDefinedString_replaced         = replace(var.userDefinedString, "_", "-")
  userDefinedString_replaced_shorten = substr(local.userDefinedString_replaced, 0, local.maxLenght - length(local.postfix) - length(local.env_4_bk) - 4)
  rsv-name                           = substr(replace("${local.env_4_bk}CNR-${var.group}-${var.project}${local.postfix}", local.regex, ""), 0, local.maxLenght)
}

# Get the RSV from the target sub
data "azurerm_recovery_services_vault" "rsv" {
  count = try(var.linux_VM.jump_server, false) == true ? 0 : 1
  name                = local.rsv-name
  resource_group_name = var.resource_groups["Backups"].name 
}

# Get the desired backup policy from the RSV
data "azurerm_backup_policy_vm" "backup_policy" {
  count = try(var.linux_VM.jump_server, false) == true ? 0 : 1
  name                = local.backup-policy-name
  recovery_vault_name = data.azurerm_recovery_services_vault.rsv[0].name
  resource_group_name = data.azurerm_recovery_services_vault.rsv[0].resource_group_name
}

resource "azurerm_backup_protected_vm" "backup_vm" {
  count               = try(var.linux_VM.disable_backup, false) == false ? 1 : 0
  resource_group_name = try(var.linux_VM.jump_server, false) == true ? var.resource_group["Backups"].name : data.azurerm_recovery_services_vault.rsv.resource_group_name
  recovery_vault_name = try(var.linux_VM.jump_server, false) == true ? local.rsv-name : data.azurerm_recovery_services_vault.rsv[0].name
  source_vm_id        = azurerm_linux_virtual_machine.vm.id
  backup_policy_id    = try(var.linux_VM.jump_server, false) == true ? var.linux_VM.backup_policy : data.azurerm_backup_policy_vm.backup_policy.id

  exclude_disk_luns = try(var.linux_VM.backup.exclude_disk_luns, null)
  include_disk_luns = try(var.linux_VM.backup.include_disk_luns, null)
  protection_state  = try(var.linux_VM.backup.protection_state, null)
}
