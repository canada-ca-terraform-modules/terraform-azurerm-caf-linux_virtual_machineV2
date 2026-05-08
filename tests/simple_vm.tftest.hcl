mock_provider "azurerm" {}
mock_provider "random" {}
mock_provider "http" {}

variables {
  location          = "canadacentral"
  env               = "DEVL"
  group             = "CNR"
  project           = "PRJ1"
  userDefinedString = "test01"
  serverType        = "SRV"

  resource_groups = {
    Project = {
      name = "rg-project"
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-project"
    }
    Backups = {
      name = "rg-backups"
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-backups"
    }
    Keyvault = {
      name = "rg-keyvault"
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-keyvault"
    }
  }

  subnets = {
    OZ = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/OZ"
    }
  }

  tags = {
    Environment = "test"
  }
}

run "naming_convention" {
  command = plan

  variables {
    linux_VM = {
      jump_server                     = true
      resource_group                  = "Project"
      admin_username                  = "azureadmin"
      disable_password_authentication = true
      vm_size                         = "Standard_D2s_v5"
      disable_backup                  = true
      backup_policy                   = "dummy-policy-id"
      patch_assessment_mode           = "AutomaticByPlatform"
      patch_mode                      = "AutomaticByPlatform"

      admin_ssh_key = {
        username   = "azureadmin"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1G9o2R8v5rcVaGCXuWCoc4XEcVcKECOZbwcTrVgetTN1vByvVj5W/T1ivu8xZOK2SuoWWA7Vl7s8qufAS37rPnbC+7oRqvR6Log7bf8LGlHRtOhEmrhfT9uOYC1poq9JSczdYU4GU5jieJghuaDFX92wNtepO8n6bcd1EfvMSNTcrbmG8+OrKc7iBGl0cBcEGaszoaD3i4VRxGuCJsatQrJorQgD01AZbESWFP+Ijb3rzcCP7TDlJ6PddDz8SrWpyRO6nW5JEVNtaPgqJTUgnM31qcGJVfA/WGF4+WqvzHFSVzwnC/Xxp4VhlNaM75uRslNFesnQi/g5RzlDgGnm/ test@example"
      }

      nic = {
        nic1 = {
          subnet = "OZ"
        }
      }

      storage_image_reference = {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
      }

      os_disk = {
        caching                   = "ReadWrite"
        storage_account_type      = "Standard_LRS"
        disk_size_gb              = 128
        write_accelerator_enabled = false
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.name == "DEVLSRV-test01"
    error_message = "Name must follow env(4)+serverType(3)-userDefinedString(7)"
  }
}

run "default_values" {
  command = plan

  variables {
    linux_VM = {
      jump_server                     = true
      resource_group                  = "Project"
      admin_username                  = "azureadmin"
      disable_password_authentication = true
      vm_size                         = "Standard_D2s_v5"
      disable_backup                  = true

      admin_ssh_key = {
        username   = "azureadmin"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1G9o2R8v5rcVaGCXuWCoc4XEcVcKECOZbwcTrVgetTN1vByvVj5W/T1ivu8xZOK2SuoWWA7Vl7s8qufAS37rPnbC+7oRqvR6Log7bf8LGlHRtOhEmrhfT9uOYC1poq9JSczdYU4GU5jieJghuaDFX92wNtepO8n6bcd1EfvMSNTcrbmG8+OrKc7iBGl0cBcEGaszoaD3i4VRxGuCJsatQrJorQgD01AZbESWFP+Ijb3rzcCP7TDlJ6PddDz8SrWpyRO6nW5JEVNtaPgqJTUgnM31qcGJVfA/WGF4+WqvzHFSVzwnC/Xxp4VhlNaM75uRslNFesnQi/g5RzlDgGnm/ test@example"
      }

      nic = {
        nic1 = {
          subnet = "OZ"
        }
      }

      storage_image_reference = {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
      }

      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "StandardSSD_LRS"
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.patch_mode == "AutomaticByPlatform"
    error_message = "patch_mode default should remain AutomaticByPlatform"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.priority == "Regular"
    error_message = "priority default should remain Regular"
  }
}

run "os_managed_disk_id_argument" {
  command = plan

  variables {
    linux_VM = {
      jump_server                     = true
      resource_group                  = "Project"
      admin_username                  = "azureadmin"
      disable_password_authentication = true
      vm_size                         = "Standard_D2s_v5"
      disable_backup                  = true
      os_managed_disk_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-project/providers/Microsoft.Compute/disks/osdisk1"

      admin_ssh_key = {
        username   = "azureadmin"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1G9o2R8v5rcVaGCXuWCoc4XEcVcKECOZbwcTrVgetTN1vByvVj5W/T1ivu8xZOK2SuoWWA7Vl7s8qufAS37rPnbC+7oRqvR6Log7bf8LGlHRtOhEmrhfT9uOYC1poq9JSczdYU4GU5jieJghuaDFX92wNtepO8n6bcd1EfvMSNTcrbmG8+OrKc7iBGl0cBcEGaszoaD3i4VRxGuCJsatQrJorQgD01AZbESWFP+Ijb3rzcCP7TDlJ6PddDz8SrWpyRO6nW5JEVNtaPgqJTUgnM31qcGJVfA/WGF4+WqvzHFSVzwnC/Xxp4VhlNaM75uRslNFesnQi/g5RzlDgGnm/ test@example"
      }

      nic = {
        nic1 = {
          subnet = "OZ"
        }
      }

      storage_image_reference = {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
      }

      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "StandardSSD_LRS"
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.os_managed_disk_id != null
    error_message = "os_managed_disk_id should be accepted when provided"
  }
}

run "hibernation_enabled_argument" {
  command = plan

  variables {
    linux_VM = {
      jump_server                     = true
      resource_group                  = "Project"
      admin_username                  = "azureadmin"
      disable_password_authentication = true
      vm_size                         = "Standard_D2s_v5"
      disable_backup                  = true

      additional_capabilities = {
        hibernation_enabled = true
      }

      admin_ssh_key = {
        username   = "azureadmin"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1G9o2R8v5rcVaGCXuWCoc4XEcVcKECOZbwcTrVgetTN1vByvVj5W/T1ivu8xZOK2SuoWWA7Vl7s8qufAS37rPnbC+7oRqvR6Log7bf8LGlHRtOhEmrhfT9uOYC1poq9JSczdYU4GU5jieJghuaDFX92wNtepO8n6bcd1EfvMSNTcrbmG8+OrKc7iBGl0cBcEGaszoaD3i4VRxGuCJsatQrJorQgD01AZbESWFP+Ijb3rzcCP7TDlJ6PddDz8SrWpyRO6nW5JEVNtaPgqJTUgnM31qcGJVfA/WGF4+WqvzHFSVzwnC/Xxp4VhlNaM75uRslNFesnQi/g5RzlDgGnm/ test@example"
      }

      nic = {
        nic1 = {
          subnet = "OZ"
        }
      }

      storage_image_reference = {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
      }

      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "StandardSSD_LRS"
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.additional_capabilities[0].hibernation_enabled == true
    error_message = "hibernation_enabled should be propagated"
  }
}

run "disk_encryption_set_id_argument" {
  command = plan

  variables {
    linux_VM = {
      jump_server                     = true
      resource_group                  = "Project"
      admin_username                  = "azureadmin"
      disable_password_authentication = true
      vm_size                         = "Standard_D2s_v5"
      disable_backup                  = true

      admin_ssh_key = {
        username   = "azureadmin"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1G9o2R8v5rcVaGCXuWCoc4XEcVcKECOZbwcTrVgetTN1vByvVj5W/T1ivu8xZOK2SuoWWA7Vl7s8qufAS37rPnbC+7oRqvR6Log7bf8LGlHRtOhEmrhfT9uOYC1poq9JSczdYU4GU5jieJghuaDFX92wNtepO8n6bcd1EfvMSNTcrbmG8+OrKc7iBGl0cBcEGaszoaD3i4VRxGuCJsatQrJorQgD01AZbESWFP+Ijb3rzcCP7TDlJ6PddDz8SrWpyRO6nW5JEVNtaPgqJTUgnM31qcGJVfA/WGF4+WqvzHFSVzwnC/Xxp4VhlNaM75uRslNFesnQi/g5RzlDgGnm/ test@example"
      }

      nic = {
        nic1 = {
          subnet = "OZ"
        }
      }

      storage_image_reference = {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
      }

      os_disk = {
        caching                = "ReadWrite"
        storage_account_type   = "StandardSSD_LRS"
        disk_encryption_set_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-security/providers/Microsoft.Compute/diskEncryptionSets/des1"
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.os_disk[0].disk_encryption_set_id != null
    error_message = "disk_encryption_set_id should be propagated"
  }
}

run "secure_vm_disk_encryption_set_id_argument" {
  command = plan

  variables {
    linux_VM = {
      jump_server                     = true
      resource_group                  = "Project"
      admin_username                  = "azureadmin"
      disable_password_authentication = true
      vm_size                         = "Standard_D2s_v5"
      disable_backup                  = true

      admin_ssh_key = {
        username   = "azureadmin"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1G9o2R8v5rcVaGCXuWCoc4XEcVcKECOZbwcTrVgetTN1vByvVj5W/T1ivu8xZOK2SuoWWA7Vl7s8qufAS37rPnbC+7oRqvR6Log7bf8LGlHRtOhEmrhfT9uOYC1poq9JSczdYU4GU5jieJghuaDFX92wNtepO8n6bcd1EfvMSNTcrbmG8+OrKc7iBGl0cBcEGaszoaD3i4VRxGuCJsatQrJorQgD01AZbESWFP+Ijb3rzcCP7TDlJ6PddDz8SrWpyRO6nW5JEVNtaPgqJTUgnM31qcGJVfA/WGF4+WqvzHFSVzwnC/Xxp4VhlNaM75uRslNFesnQi/g5RzlDgGnm/ test@example"
      }

      nic = {
        nic1 = {
          subnet = "OZ"
        }
      }

      storage_image_reference = {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
      }

      os_disk = {
        caching                          = "ReadWrite"
        storage_account_type             = "StandardSSD_LRS"
        secure_vm_disk_encryption_set_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-security/providers/Microsoft.Compute/diskEncryptionSets/cvm-des1"
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.os_disk[0].secure_vm_disk_encryption_set_id != null
    error_message = "secure_vm_disk_encryption_set_id should be propagated"
  }
}

run "security_encryption_type_argument" {
  command = plan

  variables {
    linux_VM = {
      jump_server                     = true
      resource_group                  = "Project"
      admin_username                  = "azureadmin"
      disable_password_authentication = true
      vm_size                         = "Standard_D2s_v5"
      disable_backup                  = true

      admin_ssh_key = {
        username   = "azureadmin"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1G9o2R8v5rcVaGCXuWCoc4XEcVcKECOZbwcTrVgetTN1vByvVj5W/T1ivu8xZOK2SuoWWA7Vl7s8qufAS37rPnbC+7oRqvR6Log7bf8LGlHRtOhEmrhfT9uOYC1poq9JSczdYU4GU5jieJghuaDFX92wNtepO8n6bcd1EfvMSNTcrbmG8+OrKc7iBGl0cBcEGaszoaD3i4VRxGuCJsatQrJorQgD01AZbESWFP+Ijb3rzcCP7TDlJ6PddDz8SrWpyRO6nW5JEVNtaPgqJTUgnM31qcGJVfA/WGF4+WqvzHFSVzwnC/Xxp4VhlNaM75uRslNFesnQi/g5RzlDgGnm/ test@example"
      }

      nic = {
        nic1 = {
          subnet = "OZ"
        }
      }

      storage_image_reference = {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
      }

      os_disk = {
        caching                  = "ReadWrite"
        storage_account_type     = "StandardSSD_LRS"
        security_encryption_type = "DiskWithVMGuestState"
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.os_disk[0].security_encryption_type == "DiskWithVMGuestState"
    error_message = "security_encryption_type should be propagated"
  }
}

run "diff_disk_settings_argument" {
  command = plan

  variables {
    linux_VM = {
      jump_server                     = true
      resource_group                  = "Project"
      admin_username                  = "azureadmin"
      disable_password_authentication = true
      vm_size                         = "Standard_D2s_v5"
      disable_backup                  = true

      admin_ssh_key = {
        username   = "azureadmin"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1G9o2R8v5rcVaGCXuWCoc4XEcVcKECOZbwcTrVgetTN1vByvVj5W/T1ivu8xZOK2SuoWWA7Vl7s8qufAS37rPnbC+7oRqvR6Log7bf8LGlHRtOhEmrhfT9uOYC1poq9JSczdYU4GU5jieJghuaDFX92wNtepO8n6bcd1EfvMSNTcrbmG8+OrKc7iBGl0cBcEGaszoaD3i4VRxGuCJsatQrJorQgD01AZbESWFP+Ijb3rzcCP7TDlJ6PddDz8SrWpyRO6nW5JEVNtaPgqJTUgnM31qcGJVfA/WGF4+WqvzHFSVzwnC/Xxp4VhlNaM75uRslNFesnQi/g5RzlDgGnm/ test@example"
      }

      nic = {
        nic1 = {
          subnet = "OZ"
        }
      }

      storage_image_reference = {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
      }

      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "StandardSSD_LRS"
        diff_disk_settings = {
          option    = "Local"
          placement = "CacheDisk"
        }
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.os_disk[0].diff_disk_settings[0].option == "Local"
    error_message = "diff_disk_settings.option should be propagated"
  }
}

run "resource_name_overrides" {
  command = plan

  variables {
    linux_VM = {
      jump_server                     = true
      resource_group                  = "Project"
      admin_username                  = "azureadmin"
      disable_password_authentication = true
      vm_size                         = "Standard_D2s_v5"
      disable_backup                  = true
      vm_name                         = "custom-linux-vm-name"
      nsg_name                        = "custom-linux-nsg"

      admin_ssh_key = {
        username   = "azureadmin"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1G9o2R8v5rcVaGCXuWCoc4XEcVcKECOZbwcTrVgetTN1vByvVj5W/T1ivu8xZOK2SuoWWA7Vl7s8qufAS37rPnbC+7oRqvR6Log7bf8LGlHRtOhEmrhfT9uOYC1poq9JSczdYU4GU5jieJghuaDFX92wNtepO8n6bcd1EfvMSNTcrbmG8+OrKc7iBGl0cBcEGaszoaD3i4VRxGuCJsatQrJorQgD01AZbESWFP+Ijb3rzcCP7TDlJ6PddDz8SrWpyRO6nW5JEVNtaPgqJTUgnM31qcGJVfA/WGF4+WqvzHFSVzwnC/Xxp4VhlNaM75uRslNFesnQi/g5RzlDgGnm/ test@example"
      }

      nic = {
        nic1 = {
          subnet                = "OZ"
          name                  = "custom-linux-nic1"
          ip_configuration_name = "custom-primary-ipconfig"
        }
      }

      load_balancer_address_pools_ids = {
        "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/loadBalancers/lb1/backendAddressPools/pool1" = {}
      }

      use_nic_nsg = true
      security_rules = {
        test = {
          name                         = "Allow-SSH"
          priority                     = 100
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["22"]
          source_address_prefixes      = ["*"]
          destination_address_prefixes = ["*"]
          description                  = "Allow SSH"
        }
      }

      storage_image_reference = {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
      }

      os_disk = {
        name                 = "custom-linux-osdisk"
        caching              = "ReadWrite"
        storage_account_type = "StandardSSD_LRS"
      }

      data_disks = {
        disk1 = {
          name               = "custom-linux-datadisk-1"
          disk_create_option = "Empty"
          disk_size_gb       = 128
          lun                = 0
        }
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.name == "custom-linux-vm-name"
    error_message = "VM name override should be used when provided"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.os_disk[0].name == "custom-linux-osdisk"
    error_message = "OS disk name override should be used when provided"
  }

  assert {
    condition     = azurerm_network_interface.vm-nic["nic1"].name == "custom-linux-nic1"
    error_message = "NIC name override should be used when provided"
  }

  assert {
    condition     = azurerm_network_interface.vm-nic["nic1"].ip_configuration[0].name == "custom-primary-ipconfig"
    error_message = "NIC IP configuration name override should be used when provided"
  }

  assert {
    condition     = azurerm_managed_disk.data_disks["disk1"].name == "custom-linux-datadisk-1"
    error_message = "Data disk name override should be used when provided"
  }

  assert {
    condition     = azurerm_network_security_group.NSG[0].name == "custom-linux-nsg"
    error_message = "NSG name override should be used when provided"
  }

  assert {
    condition     = azurerm_network_interface_backend_address_pool_association.LB["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/loadBalancers/lb1/backendAddressPools/pool1"].ip_configuration_name == "custom-primary-ipconfig"
    error_message = "LB association should use the first NIC ip_configuration_name override when provided"
  }
}
