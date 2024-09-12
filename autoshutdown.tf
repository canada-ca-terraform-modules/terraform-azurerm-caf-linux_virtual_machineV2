# Sets auto shutdown for the VM if configured
resource "azurerm_dev_test_global_vm_shutdown_schedule" "autoShutdown" {
  count = try(var.linux_VM.auto_shutdown_config, null) != null ? 1 : 0

  location = var.location
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id

  enabled = var.linux_VM.auto_shutdown_config.enabled
  timezone = var.linux_VM.auto_shutdown_config.timezone
  daily_recurrence_time = var.linux_VM.auto_shutdown_config.daily_recurrence_time

  notification_settings {
    enabled = var.linux_VM.auto_shutdown_config.notification_settings.enabled
    email = try(var.linux_VM.auto_shutdown_config.notification_settings.email, null)
    time_in_minutes = try(var.linux_VM.auto_shutdown_config.notification_settings.time_in_minutes, 30)
  }
} 