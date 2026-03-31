resource "azurerm_databricks_access_connector" "main" {
  name                = "databricks-access-connector"
  resource_group_name = local.resource_group
  location            = local.location

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "access_connector_storage" {
  scope                = azurerm_storage_account.datalake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.main.identity[0].principal_id
}
