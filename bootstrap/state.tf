resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_storage_account" "tfstate" {
  name                            = "st${var.project}tfstate${random_string.suffix.result}"
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS" # production: ZRS or GRS
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false # Entra ID only, no keys
  tags                            = local.tags

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id # created through ARM, not the data plane
  container_access_type = "private"
}

resource "azurerm_management_lock" "tfstate" {
  name       = "lock-tfstate"
  scope      = azurerm_storage_account.tfstate.id
  lock_level = "CanNotDelete"
  notes      = "Holds the OpenTofu state"
}
