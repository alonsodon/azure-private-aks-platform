output "id" {
  value = azurerm_key_vault.this.id
}

output "name" {
  value = azurerm_key_vault.this.name
}

output "vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}

output "private_ip" {
  value = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}

output "secret_name" {
  value = azurerm_key_vault_secret.mysql_connection.name
}