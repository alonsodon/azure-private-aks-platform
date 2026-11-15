# Roles for the person running the bootstrap (an Owner).
# Human roles are granted here, so the pipeline never needs the power to hand them out.

# Whoever runs the bootstrap (you, locally) may also read and write the state
resource "azurerm_role_assignment" "deployer_state" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "deployer_kv_officer" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Key Vault Secrets Officer" # write and read secrets from the laptop
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "deployer_aks_admin" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin" # kubectl with Entra ID
  principal_id         = data.azurerm_client_config.current.object_id
}