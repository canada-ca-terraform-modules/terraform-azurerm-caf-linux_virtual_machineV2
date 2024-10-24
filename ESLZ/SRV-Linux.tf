variable "linux_VMs" {
  description = "Object containing all windows VM parameters"
  type = any
  default = {}
}

module "linux_VMs" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-linux_virtual_machineV2.git?ref=v1.0.2"
  for_each = var.linux_VMs

  location= var.location
  env = var.env
  group = var.group
  project = var.project
  userDefinedString = each.key
  linux_VM = each.value
  resource_groups = local.resource_groups_all
  subnets = local.subnets
  user_data = try(each.value.user_data, false) != false ? base64encode(file("${path.cwd}/${each.value.user_data}")) : null

}