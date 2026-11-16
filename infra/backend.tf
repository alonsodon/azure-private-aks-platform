terraform {
  # Values come from backend.local.hcl (target) + environments/<env>.backend.hcl (state key)
  backend "azurerm" {}
}