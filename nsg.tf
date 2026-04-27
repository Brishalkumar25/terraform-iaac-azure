resource "azurerm_network_security_group" "nsg_web" {
  name                = "nsg-web"
  location            = var.location
  resource_group_name = var.resourceGroupName

  security_rule {
    name                       = "allow-appgw"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.0.2.0/24" 
    destination_address_prefix = "*"
    destination_port_ranges     = ["80","443"]
    source_port_range          = "*"
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 900
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    source_port_range          = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "web_association" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.nsg_web.id
}
