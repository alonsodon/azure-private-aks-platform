data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {}

locals {
  name_prefix = "${var.project}-${var.environment}"

  tags = {
    project     = var.project
    environment = var.environment
    managed_by  = "opentofu"
    stack       = "infra"
  }

  private_dns_zones = {
    key_vault = "privatelink.vaultcore.azure.net"
    blob      = "privatelink.blob.core.windows.net"
  }
}

module "network" {
  source = "../modules/network"

  name_prefix         = local.name_prefix
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  address_space       = var.address_space
  aks_subnet_prefix   = var.aks_subnet_prefix
  pe_subnet_prefix    = var.pe_subnet_prefix
  private_dns_zones   = local.private_dns_zones
  tags                = local.tags
}

module "key_vault" {
  source = "../modules/key-vault"

  name                       = "kv-${local.name_prefix}"
  resource_group_name        = data.azurerm_resource_group.this.name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  allowed_ip_cidrs           = var.allowed_ip_cidrs
  pe_subnet_id               = module.network.pe_subnet_id
  private_dns_zone_id        = module.network.private_dns_zone_ids["key_vault"]
  soft_delete_retention_days = var.kv_soft_delete_retention_days
  purge_protection_enabled   = var.kv_purge_protection_enabled
  tags                       = local.tags
}

module "storage" {
  source = "../modules/storage"

  name                          = "st${var.project}${var.environment}"
  resource_group_name           = data.azurerm_resource_group.this.name
  location                      = var.location
  public_network_access_enabled = var.storage_public_network_access_enabled
  allowed_ip_cidrs              = var.allowed_ip_cidrs
  pe_subnet_id                  = module.network.pe_subnet_id
  private_dns_zone_id           = module.network.private_dns_zone_ids["blob"]
  tags                          = local.tags
}