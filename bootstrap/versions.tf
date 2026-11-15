terraform {
  required_version = ">= 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}

  # Pinned per target via a git-ignored *.local.tfvars file
  subscription_id = var.subscription_id

  # Only resource-group permissions in the PRODYNA subscription: no automatic provider registration (D11)
  resource_provider_registrations = "none"

  # The state account has no access keys: talk to Storage with Entra ID tokens
  storage_use_azuread = true
}
