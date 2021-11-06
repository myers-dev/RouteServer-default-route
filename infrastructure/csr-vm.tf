#
# Deply CSR NVA with pre-provisioned config and ssh key ; spreaded across AZ evenly
#
#


module "CSR" {
  source = "../modules/generic_vm"
  
  count = var.csr_scale

  resource_group_name = var.resource_group_name
  location            = var.location

  name = "CSR${count.index}"

  subnet_id = module.vnet[0].vnet_subnets[1]

  vm_size = "Standard_DS2_v2"

  zone = count.index % 3 + 1

  custom_data = base64encode(data.template_file.csrconfig[count.index].rendered)

  storage_image_reference = {
    publisher = "cisco"
    offer = "cisco-csr-1000v"
    sku = "17_3_2-byol"
    version = "17.3.220201106"
  }

  plan = {
    name = "17_3_2-byol"
    publisher = "cisco"
    product = "cisco-csr-1000v"
  }

  public_ip_address_id = azurerm_public_ip.csr-pip[count.index].id

  disable_password_authentication = true
  admin_username = data.azurerm_key_vault_secret.keyvault-username.value
  admin_password = data.azurerm_key_vault_secret.keyvault-password.value
  ssh_key_data = data.azurerm_ssh_public_key.sshkey.public_key

  # to overcome an error of non-existent RG
  depends_on = [
    azurerm_resource_group.rg,
    module.vnet[0],
    module.vnet[1],
    module.vnet[2]
  ]

}