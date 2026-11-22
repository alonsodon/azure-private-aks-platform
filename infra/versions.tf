terraform {
  required_version = ">= 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      # Purging needs subscription-level rights; with RG-only access we leave the vault soft-deleted (random suffix avoids name clashes)
      purge_soft_delete_on_destroy = false
    }
  }
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none" # D11
  storage_use_azuread             = true
}# pipeline verification 2026-11-22
