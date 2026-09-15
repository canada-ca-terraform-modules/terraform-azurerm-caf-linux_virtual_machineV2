locals {
  # Same public resources blob account is used for the "cloud-init-default" yaml, split by env
  public_resources_account = strcontains(var.env, "G3") ? "g3pceslzresentdfa0353e" : "gcpcenteslzpublicblob4df"
  cloud_init_default_url   = "https://${local.public_resources_account}.blob.core.windows.net/publicresources/cloud-init-default.yaml"

  # custom_data may also be an arbitrary URL to fetch the script/cloud-init content from
  # Accepted custom_data keywords - keep in sync with the validation block on var.custom_data in variables.tf
  custom_data_is_keyword = try(contains(["install-ca-certs", "cloud-init-default"], var.custom_data), false)
  custom_data_is_url     = try(strcontains(var.custom_data, "http://"), false) || try(strcontains(var.custom_data, "https://"), false)
}

data "http" "custom_data" {
  count = local.custom_data_is_keyword || local.custom_data_is_url ? 1 : 0
  # "install-ca-certs" is kept as a deprecated alias of "cloud-init-default", which also runs the same install script via its own runcmd
  url = local.custom_data_is_keyword ? local.cloud_init_default_url : var.custom_data
}
