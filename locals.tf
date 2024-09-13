locals {
  # If resource_group was an ID, then parse the ID for the name, if not, then search in the provided resource_groups object
  resource_group_name = strcontains(var.linux_VM.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.linux_VM.resource_group) :  var.resource_groups[var.linux_VM.resource_group].name

  # Use TF generated passwor IF: RBAC authorization is supported on the target KV AND password_overwrite is set to false AND disabled_password_authentication is set to false
  # Use user provided password IF: RBAC authorization is NOT supported on the target KV OR password_overwrite is set to true AND disable_password_authentication is set to false
  # If disable_password_authentication is set to true, then no password is set. In this case, a ssh key is required. 
  vm-admin-password = try(var.linux_VM.disable_password_authentication, true) ? null : try(data.azurerm_key_vault.key_vault[0].enable_rbac_authorization, false) && !try(var.linux_VM.password_overwrite, false) ?  random_password.vm-admin-password[0].result : var.linux_VM.admin_password

  # If we received an ID, then parse the name from the ID, if we received the name, then format appropriately
  backup-policy-name = strcontains(try(var.linux_VM.backup_policy, "daily1"), "/resourceGroups/") ? regex("[^\\/]+$", var.linux_VM.backup_policy) : "${var.env}CNR-${var.group}_${var.project}-${try(var.linux_VM.backup_policy, "daily1")}-rsvp"

  # List of NIC ids, necessary to build a list since we might have more than one NIC created
  nics = [for nic in azurerm_network_interface.vm-nic : nic.id]
  
  # This list is used to organize the nics given to the module, used to determine which NIC will be the primary one. (At index 0)
  nic_indices = {for k, v in var.linux_VM.nic : k => index(keys(var.linux_VM.nic), k)}
}