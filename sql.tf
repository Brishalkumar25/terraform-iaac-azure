resource "azurerm_mssql_server" "azure_sql_server" {
  name                              = "sql-tst-sc-001"
  connection_policy                 = "Default"
  resource_group_name               = var.resourceGroupName
  location                          = var.location
  version                           = "12.0"
  public_network_access_enabled     = false
  minimum_tls_version               = "1.2"
  azuread_administrator {
    azuread_authentication_only = true
    login_username              = var.managed_identity_name
    object_id                   = azurerm_user_assigned_identity.umi.principal_id
    tenant_id                   = var.tenantId
  }
  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}

resource "azurerm_user_assigned_identity" "umi" {
  name                = var.managed_identity_name
  resource_group_name = var.resourceGroupName
  location            = var.location
}

resource "azurerm_mssql_database" "database" {
  collation                                                  = "SQL_Latin1_General_CP1_CI_AS"
  maintenance_configuration_name                             = "SQL_Default"
  max_size_gb                                                = 250
  min_capacity                                               = 0
  name                                                       = "db-001"
  server_id                                                  = azurerm_mssql_server.azure_sql_server.id
  sku_name                                                   = "S0"
  storage_account_type                                       = "Local"
  transparent_data_encryption_enabled                        = true
}


