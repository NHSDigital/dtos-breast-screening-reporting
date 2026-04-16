# ── Workspace ────────────────────────────────────────────────────────────────

resource "azurerm_databricks_workspace" "main" {
  name                        = "test-databricks-env-2"
  resource_group_name         = local.resource_group
  managed_resource_group_name = "databricks-rg-test-databricks-env-2"
  location                    = data.azurerm_resource_group.main.location
  sku                         = "premium"
}

# ── Access Connector ─────────────────────────────────────────────────────────

resource "azurerm_databricks_access_connector" "main" {
  name                = "databricks-access-connector"
  resource_group_name = local.resource_group
  location            = data.azurerm_resource_group.main.location

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "access_connector_storage" {
  scope                = azurerm_storage_account.datalake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.main.identity[0].principal_id
}

# ── Unity Catalog ─────────────────────────────────────────────────────────────

# Storage credential — backed by the Access Connector's managed identity
resource "databricks_storage_credential" "main" {
  name = "bsrtestdatalake_contributor"

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.main.id
  }

  depends_on = [azurerm_databricks_workspace.main]
}

# External location — points to the raw ADLS Gen2 container
resource "databricks_external_location" "raw" {
  name            = "bsrtestdatalake_raw"
  url             = "abfss://raw@${azurerm_storage_account.datalake.name}.dfs.core.windows.net/"
  credential_name = databricks_storage_credential.main.name
}

# Dev catalog
resource "databricks_catalog" "dev" {
  name         = "devs"
  comment      = "Development catalog for breast screening reporting"
  storage_root = "abfss://raw@${azurerm_storage_account.datalake.name}.dfs.core.windows.net/unity-catalog"
}

# Schemas
resource "databricks_schema" "bronze" {
  catalog_name = databricks_catalog.dev.name
  name         = "bronze"
}

resource "databricks_schema" "silver" {
  catalog_name = databricks_catalog.dev.name
  name         = "silver"
}

resource "databricks_schema" "gold" {
  catalog_name = databricks_catalog.dev.name
  name         = "gold"
}

# ── Grants ────────────────────────────────────────────────────────────────────

# Allow all workspace users to create their own per-dev schemas in devs
# (DABs mode: development deploys to bronze_<username>, silver_<username> etc.)
resource "databricks_grants" "dev_catalog" {
  catalog = databricks_catalog.dev.name

  grant {
    principal  = "BSR-Digital-Developers"
    privileges = ["USE CATALOG", "CREATE SCHEMA"]
  }
}

# Allow developers to use and query the shared CI schemas
resource "databricks_grants" "bronze_schema" {
  schema = "${databricks_catalog.dev.name}.${databricks_schema.bronze.name}"

  grant {
    principal  = "BSR-Digital-Developers"
    privileges = ["USE SCHEMA", "SELECT"]
  }
}

resource "databricks_grants" "silver_schema" {
  schema = "${databricks_catalog.dev.name}.${databricks_schema.silver.name}"

  grant {
    principal  = "BSR-Digital-Developers"
    privileges = ["USE SCHEMA", "SELECT"]
  }
}

resource "databricks_grants" "gold_schema" {
  schema = "${databricks_catalog.dev.name}.${databricks_schema.gold.name}"

  grant {
    principal  = "BSR-Digital-Developers"
    privileges = ["USE SCHEMA", "SELECT"]
  }
}
