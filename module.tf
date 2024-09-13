resource "azurerm_linux_virtual_machine" "vm" {
  name                  = local.vm-name
  location              = var.location
  resource_group_name   = local.resource_group_name
  size                  = var.linux_VM.vm_size
  admin_username        = var.linux_VM.admin_username
  admin_password        = local.vm-admin-password
  network_interface_ids = local.nics

  # Optional parameters
  allow_extension_operations                             = try(var.linux_VM.allow_extension_operations, true)
  availability_set_id                                    = try(var.linux_VM.availability_set_id, null)
  bypass_platform_safety_checks_on_user_schedule_enabled = try(var.linux_VM.bypass_platform_safety_checks_on_user_schedule_enabled, false)
  capacity_reservation_group_id                          = try(var.linux_VM.capacity_reservation_group_id, null)
  computer_name                                          = try(var.linux_VM.computer_name, local.vm-name)
  user_data                                              = var.user_data
  dedicated_host_id                                      = try(var.linux_VM.dedicated_host_id, null)
  disable_password_authentication                        = try(var.linux_VM.disable_password_authentication, true)
  dedicated_host_group_id                                = try(var.linux_VM.dedicated_host_group_id, null)
  edge_zone                                              = try(var.linux_VM.edge_zone, null)
  disk_controller_type                                   = try(var.linux_VM.disk_controller_type, null)
  encryption_at_host_enabled                             = try(var.linux_VM.encryption_at_host_enabled, null)
  eviction_policy                                        = try(var.linux_VM.eviction_policy, null)
  extensions_time_budget                                 = try(var.linux_VM.extensions_time_budget, "PT1H30M")
  license_type                                           = try(var.linux_VM.license_type, null)
  max_bid_price                                          = try(var.linux_VM.max_bid_price, -1)
  patch_assessment_mode                                  = try(var.linux_VM.patch_assessment_mode, "AutomaticByPlatform")
  patch_mode                                             = try(var.linux_VM.patch_mode, "AutomaticByPlatform")
  platform_fault_domain                                  = try(var.linux_VM.platform_fault_domain, null)
  priority                                               = try(var.linux_VM.priority, "Regular")
  provision_vm_agent                                     = try(var.linux_VM.provision_vm_agent, true)
  proximity_placement_group_id                           = try(var.linux_VM.proximity_placement_group_id, null)
  reboot_setting                                         = try(var.linux_VM.reboot_setting, "Never")
  secure_boot_enabled                                    = try(var.linux_VM.secure_boot_enabled, false)
  source_image_id                                        = try(var.linux_VM.source_image_id, null)
  virtual_machine_scale_set_id                           = try(var.linux_VM.virtual_machine_scale_set_id, null)
  vm_agent_platform_updates_enabled                      = try(var.linux_VM.vm_agent_platform_updates_enabled, false)
  vtpm_enabled                                           = try(var.linux_VM.vtpm_enabled, null)
  zone                                                   = try(var.linux_VM.zone, null)

  # Only one OS disk is accepted. Default size is 128Gb. 
  os_disk {
    name                      = "${local.vm-name}-osdisk1"
    caching                   = try(var.linux_VM.os_disk.caching, "ReadWrite")
    storage_account_type      = try(var.linux_VM.os_disk.storage_account_type, "Standard_LRS")
    disk_size_gb              = try(var.linux_VM.os_disk.disk_size_gb, null)
    write_accelerator_enabled = try(var.linux_VM.write_accelerator_enabled, false)
  }

  # Admin ssh key is NOT mutually exclusive with admin password. It is required if disable_password_authentication is set to true
  dynamic "admin_ssh_key" {
    for_each = try(var.linux_VM.admin_ssh_key, null) != null ? [1] : []
    content {
      public_key = var.linux_VM.admin_ssh_key.public_key
      username = var.linux_VM.admin_ssh_key.username
    }
  }

  # A source image ID might be given instead
  dynamic "source_image_reference" {
    for_each = try(var.linux_VM.source_image_id, null) == null ? [1] : []
    content {
      publisher = var.linux_VM.storage_image_reference.publisher
      offer     = var.linux_VM.storage_image_reference.offer
      sku       = var.linux_VM.storage_image_reference.sku
      version   = var.linux_VM.storage_image_reference.version
    }
  }

  dynamic "additional_capabilities" {
    for_each = try(var.linux_VM.additional_capabilities, null) != null ? [1] : []
    content {
      ultra_ssd_enabled   = try(var.linux_VM.additional_capabilities.ultra_ssd_enabled, false)
    }
  }

  dynamic "boot_diagnostics" {
    for_each = try(var.linux_VM.boot_diagnostic, false) != false ? [1] : []
    content {
      storage_account_uri = module.boot_diagnostic_storage[0].storage-account-object.primary_blob_endpoint
    }
  }

  dynamic "gallery_application" {
    for_each = try(var.linux_VM.gallery_application, null) != null ? [1] : []
    content {
      version_id                                  = each.value.gallery_application.version_id
      automatic_upgrade_enabled                   = try(each.value.gallery_application.automatic_upgrade_enabled, false)
      configuration_blob_uri                      = try(each.value.gallery_application.configuration_blob_uri, null)
      order                                       = try(each.value.gallery_application.order, 0)
      tag                                         = try(each.value.gallery_application.tag, null)
      treat_failure_as_deployment_failure_enabled = try(each.value.gallery_application.treat_failure_as_deployment_failure_enabled, false)
    }
  }

  # If boot diagnostic is enabled, then the VM needs a SystemAssigned identity, other acts like all other dynamic blocks
  dynamic "identity" {
    for_each = try(var.linux_VM.identity, null) != null || try(var.linux_VM.boot_diagnostic, false) == true ? [1] : []
    content {
      type         = try(var.linux_VM.identity.type, "SystemAssigned")
      identity_ids = try(var.linux_VM.identity.identity_ids, [])
    }
  }

  dynamic "secret" {
    for_each = try(var.linux_VM.secret, null) != null ? [1] : []
    content {
      dynamic "certificate" {
        for_each = var.linux_VM.secret.certificate
        content {
          url   = each.value.certificate.url
        }
      }
      key_vault_id = var.linux_VM.certificate.key_vault_id
    }
  }

  dynamic "plan" {
    for_each = try(var.linux_VM.plan, null) != null ? [1] : []
    content {
      name      = var.linux_VM.plan.name
      product   = var.linux_VM.plan.product
      publisher = var.linux_VM.plan.publisher
    }
  }

  dynamic "os_image_notification" {
    for_each = try(var.linux_VM.os_image_notification, null) != null ? [1] : []
    content {
      timeout = try(var.linux_VM.os_image_notification, "PT15M")
    }
  }

  dynamic "termination_notification" {
    for_each = try(var.linux_VM.termination_notification, null) != null ? [1] : []
    content {
      enabled = var.linux_VM.termination_notification.enabled
      timeout = try(var.linux_VM.termination_notification.timeout, "PT5M")
    }
  }

  tags = merge(var.tags, try(var.linux_VM.tags, {}), [try(var.linux_VM.computer_name, null) != null ? { "OsHostname" = var.linux_VM.computer_name } : null]...)

  lifecycle {
    ignore_changes = [admin_username, admin_password, identity, os_disk, tags]
  }
}

# More than one NIC can be configured
resource "azurerm_network_interface" "vm-nic" {
  for_each            = var.linux_VM.nic
  name                = "${local.vm-name}-nic${local.nic_indices[each.key] + 1}"
  location            = var.location
  resource_group_name = local.resource_group_name

  dns_servers                    = try(each.value.dns_servers, null)
  edge_zone                      = try(each.value.edge_zone, null)
  ip_forwarding_enabled          = try(each.value.ip_forwarding_enabled, false)
  accelerated_networking_enabled = try(each.value.accelerated_networking_enabled, false)
  internal_dns_name_label        = try(each.value.internal_dns_name_label, null)

  tags = merge(var.tags, try(each.value.tags, {}))

  # The first NIC in the list will always be the primary
  ip_configuration {
    name                          = "${local.vm-name}-ipconfig${local.nic_indices[each.key] + 1}"
    private_ip_address_allocation = try(each.value.private_ip_address_allocation, "Dynamic")
    private_ip_address            = try(each.value.private_ip_address_allocation, "Dynamic") == "Dynamic" ? null : each.value.private_ip_address
    subnet_id                     = strcontains(each.value.subnet, "/resourceGroups/") ? each.value.subnet : var.subnets[each.value.subnet].id
    private_ip_address_version    = try(each.value.nic.private_ip_address_version, "IPv4")
    primary                       = local.nic_indices[each.key] == 0 ? true : false

  }
}

resource "azurerm_managed_disk" "data_disks" {
  for_each = try(var.linux_VM.data_disks, {})

  name                 = "${local.vm-name}-datadisk${each.value.lun + 1}"
  resource_group_name  = local.resource_group_name
  location             = var.location
  storage_account_type = try(each.value.os_managed_disk_type, "StandardSSD_LRS")
  create_option        = try(each.value.disk_create_option, "Empty")
  disk_size_gb         = try(each.value.disk_size_gb, 256)

  #Optional paramaters
  disk_iops_read_write              = try(each.value.disk_iops_read_write, null)
  disk_mbps_read_write              = try(each.value.disk_mbps_read_write, null)
  disk_iops_read_only               = try(each.value.disk_iops_read_only, null)
  disk_mbps_read_only               = try(each.value.disk_mbps_read_only, null)
  upload_size_bytes                 = try(each.value.upload_size_bytes, null)
  edge_zone                         = try(each.value.edge_zone, null)
  hyper_v_generation                = try(each.value.hyper_v_generation, null)
  image_reference_id                = try(each.value.image_reference_id, null)
  gallery_image_reference_id        = try(each.value.gallery_image_reference_id, null)
  logical_sector_size               = try(each.value.logical_sector_size, null)
  optimized_frequent_attach_enabled = try(each.value.optimized_frequent_attach_enabled, false)
  performance_plus_enabled          = try(each.value.performance_plus_enabled, false)
  os_type                           = try(each.value.os_type, null)
  source_resource_id                = try(each.value.source_resource_id, null)
  source_uri                        = try(each.value.source_uri, null)
  storage_account_id                = try(each.value.storage_account_id, null)
  tier                              = try(each.value.tier, null)
  max_shares                        = try(each.value.max_shares, null)
  trusted_launch_enabled            = try(each.value.trusted_launch_enabled, null)
  security_type                     = try(each.value.security_type, null)
  secure_vm_disk_encryption_set_id  = try(each.value.secure_vm_disk_encryption_set_id, null)
  on_demand_bursting_enabled        = try(each.value.on_demand_bursting_enabled, null)
  zone                              = try(each.value.zone, null)
  public_network_access_enabled     = try(each.value.public_network_access_enabled, false)


  tags = merge(var.tags, try(each.value.tags, {}))

  lifecycle {
    ignore_changes = [name, create_option, source_resource_id, tags, zone, ]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disks_attachment" {
  for_each = try(var.linux_VM.data_disks, {})

  virtual_machine_id        = azurerm_linux_virtual_machine.vm.id
  managed_disk_id           = azurerm_managed_disk.data_disks[each.key].id
  lun                       = each.value.lun
  caching                   = try(each.value.caching, "ReadWrite")
  create_option             = try(each.value.create_option, "Attach")
  write_accelerator_enabled = try(each.value.write_accelerator_enabled, false)

  lifecycle {
    ignore_changes = [managed_disk_id, virtual_machine_id]
  }
}

# NSG usually set on subnet level, adding it here for inevitable edge cases
resource "azurerm_network_security_group" "NSG" {
  count               = try(var.linux_VM.use_nic_nsg, false) ? 1 : 0
  name                = "${local.vm-name}-nsg"
  location            = var.location
  resource_group_name = local.resource_group_name

  dynamic "security_rule" {
    for_each = [for sr in var.linux_VM.security_rules : {
      name                         = sr.name
      priority                     = sr.priority
      direction                    = sr.direction
      access                       = sr.access
      protocol                     = sr.protocol
      source_port_ranges           = split(",", replace(sr.source_port_ranges[0], "*", "0-65535"))
      destination_port_ranges      = split(",", replace(sr.destination_port_ranges[0], "*", "0-65535"))
      source_address_prefixes      = sr.source_address_prefixes
      destination_address_prefixes = sr.destination_address_prefixes
      description                  = sr.description
    }]
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_ranges           = security_rule.value.source_port_ranges
      destination_port_ranges      = security_rule.value.destination_port_ranges
      source_address_prefixes      = security_rule.value.source_address_prefixes
      destination_address_prefixes = security_rule.value.destination_address_prefixes
      description                  = security_rule.value.description
    }
  }

  tags = merge(var.tags, try(var.linux_VM.tags, {}))
}

# These last two resources are here for bacvkwards compatibility
resource "azurerm_network_interface_backend_address_pool_association" "LB" {
  for_each = try(var.linux_VM.load_balancer_address_pools_ids, {})

  network_interface_id    = azurerm_network_interface.vm-nic[keys(local.nic_indices)[0]].id
  ip_configuration_name   = "${local.vm-name}-ipconfig1"
  backend_address_pool_id = each.key
}

resource "azurerm_network_interface_application_security_group_association" "asg" {
  count = try(var.linux_VM.asg, null) != null ? 1 : 0
  network_interface_id = azurerm_network_interface.vm-nic[keys(local.nic_indices)[0]].id
  application_security_group_id = var.linux_VM.asg.application_security_group_id

}