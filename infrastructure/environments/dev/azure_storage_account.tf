terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  resource_group  = "breast-screening-reporting"
  location        = "uksouth"
  storage_account = "bsrtestdatalake"
  container       = "raw"
}

resource "azurerm_storage_account" "datalake" {
  name                     = local.storage_account
  resource_group_name      = local.resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true

  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  min_tls_version                  = "TLS1_2"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "raw" {
  name               = local.container
  storage_account_id = azurerm_storage_account.datalake.id
}
