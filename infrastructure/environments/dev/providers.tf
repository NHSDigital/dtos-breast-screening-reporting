provider "azurerm" {
  features {}
}

provider "databricks" {
  host                        = var.databricks_host
  azure_workspace_resource_id = var.databricks_workspace_resource_id
  # Auth auto-detected: Azure CLI locally, ARM_CLIENT_SECRET in CI
}
