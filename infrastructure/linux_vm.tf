
module "linux_vm" {
  source  = "Azure/compute/azurerm"
  version = "3.14.0"

  count = length(module.vnet[*].vnet_name)

  vm_os_simple        = "UbuntuServer"

  resource_group_name = var.resource_group_name
  location            = var.location

  vm_hostname = "${module.vnet[count.index].vnet_name}-vm"

  admin_username = data.azurerm_key_vault_secret.keyvault-username.value

  enable_ssh_key = true
  ssh_key_values = [ data.azurerm_ssh_public_key.sshkey.public_key ]

  vnet_subnet_id = module.vnet[count.index].vnet_subnets[1]
 

  # to overcome an error of non-existent RG
  depends_on = [
    azurerm_resource_group.rg,
    module.vnet[0],
    module.vnet[1],
    module.vnet[2]
  ]
}

