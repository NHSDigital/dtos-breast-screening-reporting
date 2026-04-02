resource "azurerm_databricks_workspace" "main" {
  name                = "test-databricks-env-2"
  resource_group_name = local.resource_group
  location            = data.azurerm_resource_group.main.location
  sku                 = "premium"
}
