
resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

resource "azurerm_virtual_machine" "generic_vm" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_size             = var.vm_size

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  zones = [ var.zone ]

  os_profile {
    computer_name = var.name
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data = var.custom_data
  }

  os_profile_linux_config {
    disable_password_authentication = var.disable_password_authentication
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = var.ssh_key_data
    }
  }

  storage_image_reference {
    publisher = var.storage_image_reference.publisher
    offer     = var.storage_image_reference.offer
    sku       = var.storage_image_reference.sku
    version   = var.storage_image_reference.version
  }

  plan {
    name = var.plan.name
    publisher = var.plan.publisher
    product = var.plan.product
  }

  storage_os_disk {
    name              = "${var.name}osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }


}

