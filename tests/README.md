# VM Test Cases

Native Terraform tests for this module are in this folder as `.tftest.hcl` files.

## Included test

- `simple_vm.tftest.hcl`: minimal VM plan simulation with test-only input objects.

## Run tests

From the repository root:

```bash
terraform init
terraform test
```

## Notes

- The test is module-level (input variable is `linux_VM`, singular).
- It uses `jump_server = true` and `disable_password_authentication = true` to reduce external lookup dependencies.
