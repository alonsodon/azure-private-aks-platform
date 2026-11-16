resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_key_vault" "this" {
  name                          = "${var.name}-${random_string.suffix.result}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true # data access through Azure RBAC roles (D23)
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = true # deployers write the secret through the public door, filtered below (D7)
  tags                          = var.tags

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = var.allowed_ip_cidrs
  }
}

resource "azurerm_private_endpoint" "this" {
  name                = "pe-${azurerm_key_vault.this.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pe_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_key_vault.this.name}"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id] # Azure creates and removes the A record (D9)
  }
}

# Generated on every run, but only written when secret_version changes; never stored in state (D24)
ephemeral "random_password" "mysql" {
  length  = 24
  special = true
}

resource "azurerm_key_vault_secret" "mysql_connection" {
  name             = var.secret_name
  key_vault_id     = azurerm_key_vault.this.id
  value_wo         = "Server=${var.mysql_host};Database=app;Uid=app;Pwd=${ephemeral.random_password.mysql.result};"
  value_wo_version = var.secret_version
}