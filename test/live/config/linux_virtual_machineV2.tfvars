# config/linux_virtual_machineV2.tfvars
# Minimal, valid fixture exercising the module's common path.
#
# admin_password is a literal, obviously-fake placeholder - never a real
# secret. disable_password_authentication = false is required alongside it
# since no ssh_key is supplied here.
#
# jump_server = true / disable_backup = true skip the RSV/backup-policy data
# source lookups entirely - this sandbox subscription has no Recovery
# Services Vault.
#
# vm_size uses the Dav6 family: the sandbox subscription's default Dsv5/
# Dasv5 family quota hits a hard Azure capacity restriction (SkuNotAvailable)
# in canadacentral - Dav6 has dedicated quota provisioned for live-test use.
linux_virtual_machineV2 = {
  userDefinedString               = "livetest"
  resource_group                  = "Project" # resolved via test_dependencies.tf's resource_groups map
  admin_username                  = "azureadmin"
  admin_password                  = "CHANGE-ME-P@ssw0rd1234!" # placeholder only - throwaway live-test VM, destroyed after use
  disable_password_authentication = false
  vm_size                         = "Standard_D2as_v6"
  jump_server                     = true
  disable_backup                  = true

  nic = {
    nic1 = {
      subnet                        = "livetest" # resolved via test_dependencies.tf's subnets map
      private_ip_address_allocation = "Dynamic"
    }
  }

  storage_image_reference = {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
