resource "azurerm_private_dns_zone" "sql_dns_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resourceGroupName
}

resource "azurerm_private_dns_zone" "kv_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resourceGroupName
}


resource "azurerm_private_dns_zone_virtual_network_link" "sql_link" {
  name                  = "sql-dns-link"
  resource_group_name   = var.resourceGroupName
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  registration_enabled = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_vnet_link" {
  name                  = "kv-dns-link"
  resource_group_name   = var.resourceGroupName
  private_dns_zone_name = azurerm_private_dns_zone.kv_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  registration_enabled = false
}

resource "azurerm_private_endpoint" "sql_private_endpoint" {
  depends_on = [azurerm_private_dns_zone.sql_dns_zone  ]
  custom_network_interface_name = "pe-sql-nic"
  location                      = var.location
  name                          = "pe-sql"
  resource_group_name           = var.resourceGroupName
  subnet_id                     = azurerm_subnet.db.id
  private_dns_zone_group {
    name                 = "privatelink-database-windows-net"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_dns_zone.id]
  }
  private_service_connection {
    is_manual_connection              = false
    name                              = "pe-sql"
    private_connection_resource_id    = azurerm_mssql_server.azure_sql_server.id
    subresource_names                 = ["sqlServer"]
  }
}

resource "azurerm_private_endpoint" "kv_private_endpoint" {
  depends_on = [azurerm_private_dns_zone.kv_dns_zone  ]
  custom_network_interface_name = "pe-kv-nic"
  location                      = var.location
  name                          = "pe-kv"
  resource_group_name           = var.resourceGroupName
  subnet_id                     = azurerm_subnet.web.id
  private_dns_zone_group {
    name                 = "privatelink-vaultcore-azure-net"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv_dns_zone.id]
  }
  private_service_connection {
    is_manual_connection              = false
    name                              = "pe-kv"
    private_connection_resource_id    = azurerm_key_vault.kv.id
    subresource_names                 = ["vault"]
  }
}