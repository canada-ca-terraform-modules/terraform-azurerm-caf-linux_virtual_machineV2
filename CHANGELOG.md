# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `custom_data` now also accepts an arbitrary `http://`/`https://` URL, fetched and base64-encoded the same way as the existing `install-ca-certs` keyword (previously only that hard-coded keyword or a base64-encoded value/local file path were supported).
- `custom_data` accepts a new `"cloud-init-default"` keyword, resolving to a G3/non-G3-specific `cloud-init-default.yaml` public blob based on `var.env`.

### Changed

- `install-ca-certs` is now a deprecated alias of `cloud-init-default`: it resolves to the same `cloud-init-default.yaml`, which installs the CA certs and also runs the original `linux-ubuntu-customdata-default.sh` script via `runcmd` (previously `install-ca-certs` fetched that `.sh` script directly).
- `ESLZ/*.tfvars` examples now default `custom_data` to `"cloud-init-default"` instead of `"install-ca-certs"`.

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
