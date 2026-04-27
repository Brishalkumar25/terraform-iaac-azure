resource "azurerm_route_table" "rt_web" {
  name                = "rt-web"
  location            = var.location
  resource_group_name = var.resourceGroupName
}

resource "azurerm_route" "route_to_fw" {
  name                   = "route-to-firewall"
  resource_group_name    = var.resourceGroupName
  route_table_name       = azurerm_route_table.rt_web.name

  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.4.4"  # assume its the private ip of azure firewall
}

resource "azurerm_subnet_route_table_association" "web_assoc" {
  subnet_id      = azurerm_subnet.web.id
  route_table_id = azurerm_route_table.rt_web.id
}