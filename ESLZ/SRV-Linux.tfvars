linux_VMs = {
  test = {
    serverType     = "SRV"
    postfix        = "01"
    resource_group = "Project"
    admin_username = "azureadmin"
    # admin_password          = "Canada123!"                          # Optional: Only set the password if a generated password cannot be created. See README for details
    # password_overwrite = false                                       # Optional: Set this to true if you absolutely want to set the admin password above
    vm_size              = "Standard_D2s_v5"
    disable_password_authentication = true

    backup_policy = "daily1"                                                                                     # Optional: Set this value to configure backup policy on the VM. Can be either userDefinedString portion of the policy name or ID. Defaults to daily1 
    # disable_backup           = false                                                                             # Optional: Set this value to true if you want to disable backups on this VM    
    patch_assessment_mode    = "AutomaticByPlatform" # force settings to AutomaticByPlatform for UMC OS patching 
    patch_mode               = "AutomaticByPlatform" # force settings to AutomaticByPlatform for UMC OS patching 
    # computer_name                                          = "Example"                                           # Optional: Set this if you need the guest OS Hostname to be different than the Azure resource name
    # user_data                                              = "post_install_scripts/ubuntu/post_install.sh"       # Optional: Set this value with the relative path to the file from your CWD.
    # boot_diagnostic                                        = true
    # use_nic_nsg                                            = true

    # At least one nic is required. If more than one is present, the first nic in the list will be the primary one.
    nic = {
      nic1 = {
        subnet                        = "APP"
        private_ip_address_allocation = "Static"
        private_ip_address            = "172.17.65.8"

        # dns_servers                    = []
        # edge_zone                      = ""
        # ip_forwarding_enabled          = false
        # accelerated_networking_enabled = false
        # internal_dns_name_label        = ""
      }
    }

    # Optional: Uncomment if you need to configure admin ssh key.  
    # admin_ssh_key = {
    #   public_key = ""
    #   username = "azureadmin"
    # }

    storage_image_reference = {
      publisher = "canonical",
      offer     = "0001-com-ubuntu-server-jammy",
      sku       = "22_04-lts-gen2",
      version   = "latest"
    }

    # Optional: Uncomment if you need to configure os_disk with different defaults than below. Only supports one os_disk
    os_disk = {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
      disk_size_gb = 128
      write_accelerator_enabled = false
    }

    # Optional: Uncomment and configure data disks for the VM. Can create more than one data disks.
    # data_disks = {
    #   disk1 = {
    #     storage_account_type = "StandardSSD_LRS"
    #     disk_create_option = "Empty"
    #     disk_size_gb = 500
    #     lun = 0
    #     caching = "ReadWrite"
    #   }
    # }

    # Optional: Uncomment this block to setup auto-shutdown on the VM.
    # auto_shutdown_config = {
    #   enabled               = true
    #   timezone              = "Eastern Standard Time"
    #   daily_recurrence_time = "1600"

    #   notification_settings = {
    #     enabled = true
    #     email = "maxime.mahdavian@ssc-spc.gc.ca"
    #     time_in_minutes = 30
    #   }
    # }

    # Optional: Uncomment this if you want to set an identityfor the VM. Note that if boot_diagnostic is Enabled then a SystemAssigned identity is automatically granted to the VM. 
    # identity = {
    #   type         = "SystemAssigned"
    #   identity_ids = []
    # }
  }
}
