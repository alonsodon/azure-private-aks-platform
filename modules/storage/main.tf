resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_storage_account" "this" {
  name                            = "${var.name}${random_string.suffix.result}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false # Entra ID only
  public_network_access_enabled   = var.public_network_access_enabled
  tags                            = var.tags

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = [for c in var.allowed_ip_cidrs : trimsuffix(c, "/32")] # storage IP rules take plain IPs, not /32
  }
}

resource "azurerm_storage_container" "this" {
  for_each              = toset(var.container_names)
  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id # through ARM: works with the data plane closed
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "blob" {
  name                = "pe-${azurerm_storage_account.this.name}-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pe_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.this.name}-blob"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}