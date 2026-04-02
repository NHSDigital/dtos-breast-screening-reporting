resource "azurerm_databricks_workspace" "main" {
  name                        = "test-databricks-env-2"
  resource_group_name         = local.resource_group
  managed_resource_group_name = "databricks-rg-test-databricks-env-2"
  location                    = data.azurerm_resource_group.main.location
  sku                         = "premium"
}
