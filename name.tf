locals {
  linux_virtual_machine_regex = "/[//\"'\\[\\]:|<>+=;,?*@&]/" # Can't include those characters in windows_virtual_machine name: \/"'[]:|<>+=;,?*@&
  env_4                         = substr(var.env, 0, 4)
  serverType_3                  = substr(var.serverType, 0, 3)
  userDefinedString_7           = substr(var.userDefinedString, 0, 7)
  vm-name                       = replace("${local.env_4}${local.serverType_3}-${local.userDefinedString_7}", local.linux_virtual_machine_regex, "")
}