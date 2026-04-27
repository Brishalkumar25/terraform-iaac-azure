resource "azurerm_virtual_network" "vnet" {
  depends_on = [azurerm_resource_group.resourceGroup  ]
  name                = var.virtualnetwork
  address_space       = var.addresspace_vnet001
  location            = var.location
  resource_group_name = var.resourceGroupName
}

resource "azurerm_subnet" "web" {
  depends_on = [azurerm_virtual_network.vnet  ]
  name                 = var.subnetweb_name
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnetweb_address
}

resource "azurerm_subnet" "appgw" {
  depends_on = [azurerm_virtual_network.vnet  ]
  name                 = var.subnet_appGW_name
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_appGW_address
}

resource "azurerm_subnet" "db" {
  depends_on = [azurerm_virtual_network.vnet  ]
  name                 = var.subnet_db_name
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_db_address
}