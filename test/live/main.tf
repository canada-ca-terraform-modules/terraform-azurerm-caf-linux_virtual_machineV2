terraform {
  # no-op touch: satisfies live-test.yml's test/live/** path filter for the workflow-only PR
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }

  # Empty on purpose: the state file path is supplied at `terraform init`
  # time via `-backend-config="path=..."` (partial configuration), so the
  # target-branch checkout and the PR-branch checkout can point at the same
  # external state file without either owning its own local state.
  backend "local" {}
}

provider "azurerm" {
  storage_use_azuread             = true
  resource_provider_registrations = "legacy"
  features {}
}

module "linux_virtual_machineV2" {
  # PR code and baseline code are two on-disk checkouts of this same repo,
  # not two resolved git refs - no pinned ?ref, no version toggle here.
  source = "../../"

  location          = var.location
  env               = var.env
  group             = var.group
  project           = var.project
  userDefinedString = try(var.linux_virtual_machineV2.userDefinedString, "livetest")
  serverType        = try(var.linux_virtual_machineV2.serverType, "SWJ")
  linux_VM          = var.linux_virtual_machineV2
  resource_groups   = local.resource_groups # from test_dependencies.tf
  subnets           = local.subnets         # from test_dependencies.tf
  tags              = var.tags
}
