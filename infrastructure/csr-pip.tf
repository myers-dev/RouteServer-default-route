#
# Public IP for CSRs
#

resource "azurerm_public_ip" "csr-pip" {
  count               = var.csr_scale
  name                = "csr-pip${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  
  # to overcome an error of non-existent RG
  depends_on = [
    azurerm_resource_group.rg,
    module.vnet[0],
    module.vnet[1],
    module.vnet[2]
  ]
}

