data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                          = var.key_vault_name
  location                      = var.location
  resource_group_name           = var.resourceGroupName
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = true
  soft_delete_retention_days    = 7
  rbac_authorization_enabled    = true
  public_network_access_enabled = false
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

# assign rbac to service principal
resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
}

# resource "azurerm_role_assignment" "appgw_kv_access" {
#   scope                = azurerm_key_vault.kv.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_application_gateway.appgw.identity[0].principal_id
# }

data "azurerm_key_vault_certificate" "cert" {
  name         = "cert-appgw-https"
  key_vault_id = azurerm_key_vault.kv.id
}