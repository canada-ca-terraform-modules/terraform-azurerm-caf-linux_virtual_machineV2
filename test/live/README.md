# Live test harness

This `test/live/` directory is a real-Azure per-PR test harness, wired to
`.github/workflows/live-test.yml`. It applies the module against a throwaway
resource group + vnet/subnet, owned entirely by this harness.

## What it deploys

- A dedicated resource group + vnet/subnet (`test_dependencies.tf`), suffixed
  with `var.pr_number` so concurrently open PRs never collide.
- One `terraform-azurerm-caf-linux_virtual_machineV2` instance
  (`config/linux_virtual_machineV2.tfvars`), using the `Dav6` VM size family -
  the sandbox subscription's default `Dsv5`/`Dasv5` family quota hits a hard
  Azure capacity restriction in `canadacentral`.
- `jump_server = true` / `disable_backup = true` in the fixture skip the
  RSV/backup-policy data source lookups entirely - this sandbox subscription
  has no Recovery Services Vault.

## Manual run

```bash
cd test/live
terraform init -backend-config="path=/tmp/live-test-manual.tfstate"
terraform plan -var-file=config/linux_virtual_machineV2.tfvars
terraform apply -var-file=config/linux_virtual_machineV2.tfvars
# ...
terraform destroy -var-file=config/linux_virtual_machineV2.tfvars
```

See the repo root's `.github/workflows/live-test.yml` for how CI wires two
checkouts (target branch baseline + PR branch) against the same state file.
<!-- no-op: verification PR for the live-test.yml conversion -->

