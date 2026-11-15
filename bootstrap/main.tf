# The resource group already exists: we read it, we never create or delete it
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {}

locals {
  tags = {
    project    = var.project
    managed_by = "opentofu"
    stack      = "bootstrap"
  }
}
