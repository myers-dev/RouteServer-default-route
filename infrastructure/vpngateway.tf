resource "azurerm_virtual_network_gateway" "VPNGW" {
  name                = "VPNGW"
  resource_group_name = var.resource_group_name
  location            = var.location

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = true
  sku           = "VpnGw1AZ"

  bgp_settings {
    asn = 65559
  }

  ip_configuration {
    name                          = "vnetGatewayConfig1"
    public_ip_address_id          = azurerm_public_ip.vpngw-pip[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.vnet[2].vnet_subnets[0]
  }

  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.vpngw-pip[1].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.vnet[2].vnet_subnets[0]
  }

  # to overcome an error of non-existent RG
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_local_network_gateway" "CSR" {
  count = var.csr_scale
  name                = "CSR${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location

  gateway_address     = azurerm_public_ip.csr-pip[count.index].ip_address

  bgp_settings {
    asn = 65555
    bgp_peering_address = "192.168.100.${count.index}"
  }
  # to overcome an error of non-existent RG
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_virtual_network_gateway_connection" "CSR" {
  count = var.csr_scale
  name                = "CSR${count.index}"

  resource_group_name = var.resource_group_name
  location            = var.location

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.VPNGW.id
  local_network_gateway_id   = azurerm_local_network_gateway.CSR[count.index].id

  enable_bgp = true

  shared_key = data.azurerm_key_vault_secret.sharedkey.value

  # to overcome an error of non-existent RG
  depends_on = [
    azurerm_resource_group.rg,
    module.vnet[0],
    module.vnet[1],
    module.vnet[2]
  ]
}
