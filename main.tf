
data "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_resource_group" "resourceGroup" {
  name     = var.resourceGroupName
  location = var.location
}

