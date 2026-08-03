# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.0.0] - 2026-08-03

### Changed

- **Breaking:** Bumped the `azurerm` provider version constraint from `~> 4.0` to `~> 5.0` (target `5.0.1`). Consumers pinned to `azurerm` 4.x elsewhere in the same root module will need to upgrade in lockstep.
- Bumped the `boot_diagnostic_storage` child module (`terraform-azurerm-caf-storage_accountV2`) reference from `v1.0.5` to `v1.2.0` (its `providers.tf` already requires `azurerm ~> 5.0`, so this is required for compatibility).

### Added

- `azurerm_network_interface`: exposed `auxiliary_mode` and `auxiliary_sku` (NVA high-performance networking, preview), and `ip_configuration.gateway_load_balancer_frontend_ip_configuration_id`.
- `azurerm_managed_disk` (data disks): exposed `disk_encryption_set_id`, `network_access_policy`, `disk_access_id`, and the `encryption_settings` block (`disk_encryption_key` / `key_encryption_key`).
- `azurerm_network_security_group` `security_rule`: exposed `source_application_security_group_ids` and `destination_application_security_group_ids`.
- `tests/simple_vm.tftest.hcl`: added coverage for all of the above new arguments.

### Known blockers

- None. No resource in this module is affected by the azurerm 5.0 removed/renamed properties in the [5.0 upgrade guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/5.0-upgrade-guide) — `azurerm_linux_virtual_machine`'s only breaking change (`vm_agent_platform_updates_enabled` becoming read-only) was never set by this module.

## [1.1.2] and earlier

Released prior to this module adopting a CHANGELOG. See git history / GitHub releases for details.
