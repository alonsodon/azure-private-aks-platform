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

  # D42: encrypt state and saved plans; the plan travels between jobs as an artifact
  encryption {
    key_provider "pbkdf2" "main" {
      passphrase = var.state_passphrase
    }
    method "aes_gcm" "main" {
      keys = key_provider.pbkdf2.main
    }
    state {
      method   = method.aes_gcm.main
      enforced = true # never write the state unencrypted
    }
    plan {
      method   = method.aes_gcm.main
      enforced = true # never write a saved plan unencrypted
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
}