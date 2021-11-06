resource "azurerm_route_table" "RT" {
  name                          = "no_bgp_rt"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = true
}

resource "azurerm_subnet_route_table_association" "RT" {
  subnet_id      = module.vnet[0].vnet_subnets[1]
  route_table_id = azurerm_route_table.RT.id
}