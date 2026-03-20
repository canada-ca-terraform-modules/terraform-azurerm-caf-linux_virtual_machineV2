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

run "baseline_apply" {
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
    condition     = azurerm_linux_virtual_machine.vm.name == "DEVLSRV-test01"
    error_message = "Baseline apply should keep existing VM naming"
  }
}

run "upgrade_plan_no_replacement" {
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
    condition     = azurerm_linux_virtual_machine.vm.name == "DEVLSRV-test01"
    error_message = "Upgrade plan must preserve VM name"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.additional_capabilities[0].hibernation_enabled == true
    error_message = "Upgrade plan should apply new optional arguments in-place"
  }
}
