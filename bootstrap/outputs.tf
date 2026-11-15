output "resource_group_name" { value = data.azurerm_resource_group.this.name }
output "state_storage_account_name" { value = azurerm_storage_account.tfstate.name }
output "state_container_name" { value = azurerm_storage_container.tfstate.name }
output "pipeline_client_id" { value = azurerm_user_assigned_identity.pipeline.client_id }
output "tenant_id" { value = data.azurerm_client_config.current.tenant_id }
