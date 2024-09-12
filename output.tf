output "linux_vm_object" {
  description = "Outputs the entire VM object"
  value = azurerm_linux_virtual_machine.vm
}

output "linux_vm_id" {
  description = "Outputs the id of the VM"
  value = azurerm_linux_virtual_machine.vm.id
}

output "linux_vm_name" {
  description = "Outputs the name of the VM"
  value = azurerm_linux_virtual_machine.vm.name
}