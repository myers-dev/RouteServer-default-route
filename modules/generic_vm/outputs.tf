output "azurerm_virtual_machine_name" {
  value = azurerm_virtual_machine.generic_vm.name
}

output "azurerm_virtual_machine_id" {
  value = azurerm_virtual_machine.generic_vm.id
}

output "azurerm_network_interface_name" {
  value = azurerm_network_interface.nic.name
}

output "azurerm_network_interface_id" {
  value = azurerm_network_interface.nic.id
}

output "azurerm_network_interface_ip_configuration_name" {
  value = azurerm_network_interface.nic.ip_configuration.*.name
}

output "azurerm_network_interface_private_ip_address" {
  value = azurerm_network_interface.nic.private_ip_address
}
