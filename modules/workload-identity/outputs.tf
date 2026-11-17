output "client_id" {
  value = azurerm_user_assigned_identity.this.client_id # goes into the ServiceAccount annotation
}

output "principal_id" {
  value = azurerm_user_assigned_identity.this.principal_id
}