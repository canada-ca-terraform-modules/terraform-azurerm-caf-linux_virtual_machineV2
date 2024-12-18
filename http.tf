locals {
  custom_data_url = strcontains(var.env, "G3") ? "https://g3pceslzresentdfa0353e.blob.core.windows.net/publicresources/linux-ubuntu-customdata-default.sh" : "https://gcpcenteslzpublicblob4df.blob.core.windows.net/publicresources/linux-ubuntu-customdata-default.sh"
}

data "http" "custom_data" {
  count = var.custom_data == "install-ca-certs" ? 1 : 0
  url = local.custom_data_url
}