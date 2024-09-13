## Providers

| Name    | Version |
| ------- | ------- |
| azurerm | 4.0.0   |
| random  | n/a     |

## Inputs

| Name              | Description                                                                   | Type          | Default           | Required |
| ----------------- | ----------------------------------------------------------------------------- | ------------- | ----------------- | :------: |
| env               | (Required) 4 character string defining the environment name prefix for the VM | `string`      | n/a               |   yes    |
| group             | (Required) Character string defining the group for the target subscription    | `string`      | n/a               |   yes    |
| location          | Azure location for the VM                                                     | `string`      | `"canadacentral"` |    no    |
| project           | (Required) Character string defining the project for the target subscription  | `string`      | n/a               |   yes    |
| resource\_groups  | (Required) Resource group object for the VM                                   | `any`         | `{}`              |    no    |
| serverType        | 3 character string defining the server type for the VM                        | `string`      | `"SRV"`           |    no    |
| subnets           | (Required) List of subnet objects for the VM                                  | `any`         | n/a               |   yes    |
| tags              | Tags that will be applied to every associated VM resource                     | `map(string)` | `{}`              |    no    |
| userDefinedString | (Required) User defined portion value for the name of the VM.                 | `string`      | n/a               |   yes    |
| user\_data        | Base64 encoded file representing user data script for the VM                  | `any`         | `null`            |    no    |
| linux\_VM         | Object containing all VM parameters                                           | `any`         | `{}`              |    no    |

## Outputs

| Name              | Description                  |
| ----------------- | ---------------------------- |
| linux\_vm\_id     | Outputs the id of the VM     |
| linux\_vm\_name   | Outputs the name of the VM   |
| linux\_vm\_object | Outputs the entire VM object |

## Admin password

The administrator password can be automatically generated by terraform or can be set by the user. In the case of a generated password, it will be stored in the subscription key vault. Please also note that an admin password is not mutually exclusive with admin passwords.\
 Here are the rules for the admin password:

- A generated password by terraform wil be used IF RBAC authorization is enabled on the subscription keyvault AND password_overwrite it set to false AND disable_password_authorization is set to false
- A user chosen password will be used IF RBAC authorization is disabled on the subscription keyvault OR password_overwrite is set to true AND disable_password_authentication is set to false
- No password will be configured if disable_password_authentication is set to true. In this case, an admin ssh key needs to be configured.

## TFVAR parameters

### VM Main Block Parameters

| Parameter Name                                         | Possible Value                           | Required | Default Value       |
| ------------------------------------------------------ | ---------------------------------------- | -------- | ------------------- |
| serverType                                             | SWJ                                      | Yes      | SWJ                 |
| postfix                                                | String                                   | Yes      | 01                  |
| resource_group                                         | RG name or ID                            | Yes      | n/a                 |
| admin_username                                         | string                                   | Yes      | azureadmin          |
| admin_password                                         | string                                   | No       | n/a                 |
| password_overwrite                                     | int                                      | No       | false               |
| vm_size                                                | Valid VM sku                             | Yes      | Standard_D2s_v5     |
| backup_policy                                          | userDefinedString part of name or ID     | No       | daily1              |
| disable_backup                                         | true,false                               | No       | false               |
| enable_automatic_updates                               | true,false                               | No       | true                |
| patch_assessment_mode                                  | AutomaticByPlatform,ImageDefault         | Yes      | AutomaticByPlatform |
| patch_mode                                             | Manual,AutomaticByOS,AutomaticByPlatform | Yes      | AutomaticByPlatform |
| computer_name                                          | string                                   | No       | n/a                 |
| user_data                                              | file path                                | No       | n/a                 |
| boot_diagnostic                                        | true,false                               | No       | false               |
| use_nic_nsg                                            | true,false                               | No       | false               |
| allow_extension_operations                             | true,false                               | No       | true                |
| availability_set_id                                    | Azure ID                                 | No       | n/a                 |
| bypass_platform_safety_checks_on_user_schedule_enabled | true,false                               | No       | false               |
| capacity_reservation_group_id                          | Azure ID                                 | No       | n/a                 |
| dedicated_host_id                                      | Azure ID                                 | No       | n/a                 |
| dedicated_host_group_id                                | Azure ID                                 | No       | n/a                 |
| edge_zone                                              | Azure edge zone                          | No       | n/a                 |
| disk_controller_type                                   | SCSI,NVMe                                | No       | n/a                 |
| encryption_at_host_enabled                             | true,false                               | No       | n/a                 |
| eviction_policy                                        | Deallocate,Delete                        | No       | n/a                 |
| extensions_time_budget                                 | PT1H30M                                  | No       | PT1H30M             |
| hotpatching_enabled                                    | true,false                               | No       | false               |
| license_type                                           | None,linux_Client,linux_Server           | No       | n/a                 |
| max_bid_price                                          | int or -1 for disabled                   | No       | -1                  |
| platform_fault_domain                                  | Azure fault domain                       | No       | n/a                 |
| priority                                               | Regular,Spot                             | No       | Regular             |
| provision_vm_agent                                     | true,false                               | No       | true                |
| proximity_placement_group_id                           | Azure ID                                 | No       | n/a                 |
| reboot_setting                                         | Always,IfRequired,Never                  | No       | Never               |
| secure_boot_enabled                                    | true,false                               | No       | false               |
| source_image_id                                        | Azure ID                                 | No       | n/a                 |
| timezone                                               | Valid timezone                           | No       | UTC-11              |
| virtual_machine_scale_set_id                           | Azure ID                                 | No       | n/a                 |
| vm_agent_platform_updates_enabled                      | true,false                               | No       | false               |
| vtpm_enabled                                           | true,false                               | No       | false               |
| zone                                                   | Azure availability zone                  | No       | n/a                 |
| tags                                                   | map of strings                           | No       | n/a                 |

### NIC Block

| Parameter Name                 | Possible Value       | Required | Default Value |
| ------------------------------ | -------------------- | -------- | ------------- |
| subnet                         | Subnet name or ID    | Yes      | n/a           |
| private_ip_address_allocation  | Dynamic,Static       | Yes      | Dynamic       |
| private_ip_address             | IP address           | Yes      | n/a           |
| dns_servers                    | List of IP addresses | No       | n/a           |
| edge_zone                      | Azure Edge zone      | No       | n/a           |
| ip_forwarding_enabled          | true,false           | No       | false         |
| accelerated_networking_enabled | true,false           | No       | false         |
| internal_dns_name_label        | string               | No       | n/a           |
| tags                           | map of strings       | No       | n/a           |

### Admin SSH Keys block

| Parameter Name | Possible Value           | Required | Default Value |
| -------------- | ------------------------ | -------- | ------------- |
| public_key     | Valid ssh-rsa public key | Yes      | n/a           |
| username       | string                   | Yes      | n/a           |

### Storage Image Reference Block 

| Parameter Name | Possible Value | Required | Default Value |
| -------------- | -------------- | -------- | ------------- |
| publisher      | string         | Yes      | n/a           |
| offer          | string         | Yes      | n/a           |
| sku            | string         | Yes      | n/a           |
| version        | string         | Yes      | n/a           |


### OS Disk Block

| Parameter Name            | Possible Value          | Required | Default Value |
| ------------------------- | ----------------------- | -------- | ------------- |
| caching                   | None,ReadOnly,ReadWrite | No       | ReadWrite     |
| storage_account_type      | Check TF Doc            | No       | Standard_LRS  |
| disk_size_gb              | int                     | No       | 128           |
| write_accelerator_enabled | true,false              | No       | false         |

### Data Disks Block

| Parameter Name                    | Possible Value          | Required | Default Value   |
| --------------------------------- | ----------------------- | -------- | --------------- |
| name                              | string                  | Yes      | n/a             |
| resource_group_name               | name or ID              | Yes      | n/a             |
| storage_account_type              | See TF Doc              | No       | StandardSSD_LRS |
| create_option                     | See Tf Doc              | No       | Empty           |
| disk_size_gb                      | int                     | No       | 256             |
| disk_iops_read_write              | int                     | No       | null            |
| disk_mbps_read_write              | int                     | No       | null            |
| disk_iops_read_only               | int                     | No       | null            |
| disk_mbps_read_only               | int                     | No       | null            |
| upload_size_bytes                 | int                     | No       | null            |
| edge_zone                         | Azure edge zone         | No       | null            |
| hyper_v_generation                | V1,V2                   | No       | null            |
| image_reference_id                | Azure ID                | No       | null            |
| gallery_image_reference_id        | Azure ID                | No       | null            |
| logical_sector_size               | int                     | No       | null            |
| optimized_frequent_attach_enabled | true,false              | No       | false           |
| performance_plus_enabled          | true,false              | No       | false           |
| os_type                           | linux                   | No       | null            |
| source_resource_id                | Azure ID                | No       | null            |
| source_uri                        | URI                     | No       | null            |
| storage_account_id                | Azure ID                | No       | null            |
| tier                              | See TF Doc              | No       | null            |
| max_shares                        | int                     | No       | null            |
| trusted_launch_enabled            | true,false              | No       | null            |
| security_type                     | See TF Doc              | No       | null            |
| secure_vm_disk_encryption_set_id  | Azure ID                | No       | null            |
| on_demand_bursting_enabled        | true,false              | No       | null            |
| zone                              | Azure Availability zone | No       | null            |
| public_network_access_enabled     | true,false              | No       | false           |
| tags                              | map of strings          | No       | n/a             |

### Auto Shutdown Config Block

| Parameter Name                        | Possible Value              | Required | Default Value |
| ------------------------------------- | --------------------------- | -------- | ------------- |
| enabled                               | true,false                  | Yes      | n/a           |
| timezone                              | See Azure Valid timezone    | Yes      | n/a           |
| daily_recurrence_time                 | Time Format: HHmm, eg. 1630 | Yes      | n/a           |
| notification_settings.enabled         | true,false                  | Yes      | n/a           |
| notification_settings.email           | string                      | No       | n/a           |
| notification_settings.time_in_minutes | int                         | No       | 30            |

### Identity Block 

| Parameter Name | Possible Value              | Required | Default Value |
| -------------- | --------------------------- | -------- | ------------- |
| type           | SystemAssigned,UserAssigned | Yes      | n/a           |
| identity_ids   | List of IDs                 | No       | n/a           |

### Additional Capabilities Block 

| Parameter Name      | Possible Value | Required | Default Value |
| ------------------- | -------------- | -------- | ------------- |
| ultra_ssd_enabled   | true,false     | Yes      | n/a           |
| hibernation_enabled | true,false     | Yes      | n/a           |

### Gallery Application Block

| Parameter Name                              | Possible Value | Required | Default Value |
| ------------------------------------------- | -------------- | -------- | ------------- |
| version_id                                  | Azure ID       | Yes      | n/a           |
| automatic_upgrade_enabled                   | true,false     | No       | n/a           |
| configuration_blob_uri                      | URI            | No       | n/a           |
| order                                       | int            | No       | n/a           |
| tag                                         | string         | No       | n/a           |
| treat_failure_as_deployment_failure_enabled | true,false     | No       | n/a           |

### Secret Block

| Parameter Name    | Possible Value | Required | Default Value |
| ----------------- | -------------- | -------- | ------------- |
| certificate.store | Cert store     | Yes      | n/a           |
| certificate.url   | URL            | Yes      | n/a           |
| key_vault_id      | Azure ID       | Yes      | n/a           |

### Plan Block

| Parameter Name | Possible Value             | Required | Default Value |
| -------------- | -------------------------- | -------- | ------------- |
| name           | Marketplace image name     | Yes      | n/a           |
| product        | Marketplace product name   | Yes      | n/a           |
| publisher      | Marketplace publisher name | Yes      | n/a           |

### OS Image Notification Block

| Parameter Name | Possible Value | Required | Default Value |
| -------------- | -------------- | -------- | ------------- |
| timeout        | PT15M          | No       | PT15M         |

### Termination Notification Block

| Parameter Name | Possible Value                | Required | Default Value |
| -------------- | ----------------------------- | -------- | ------------- |
| enabled        | true,false                    | Yes      | n/a           |
| timeout        | PTXM where X between 5 and 15 | No       | n/a           |


### Security Rules Block

| Parameter Name               | Possible Value | Required | Default Value |
| ---------------------------- | -------------- | -------- | ------------- |
| name                         | string         | Yes      | n/a           |
| priority                     | int            | Yes      | n/a           |
| access                       | string         | Yes      | n/a           |
| protocol                     | string         | Yes      | n/a           |
| direction                    | string         | Yes      | n/a           |
| source_port_ranges           | list of string | Yes      | n/a           |
| source_address_prefixes      | list of string | Yes      | n/a           |
| destination_port_ranges      | list of string | Yes      | n/a           |
| destination_address_prefixes | list of string | Yes      | n/a           |
| description                  | string         | Yes      | n/a           |
| tags                         | map of strings | No       | n/a           |

### Load_balancer Address Pool

| Parameter Name             | Possible Value | Required | Default Value |
| -------------------------- | -------------- | -------- | ------------- |
| Address pool ID as the key | Azure ID       | yes      | n/a           |

### Aplication Security Group Association (ASG)

| Parameter Name | Possible Value | Required | Default Value |
| -------------- | -------------- | -------- | ------------- |
| id             | Azure ID       | Yes      | n/a           |