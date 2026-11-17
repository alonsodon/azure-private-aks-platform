resource "azurerm_user_assigned_identity" "this" {
  name                = "id-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Entra ID accepts tokens from this cluster's issuer for exactly this ServiceAccount
resource "azurerm_federated_identity_credential" "this" {
  name                      = "fc-${var.namespace}-${var.service_account_name}"
  user_assigned_identity_id = azurerm_user_assigned_identity.this.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = var.oidc_issuer_url
  subject                   = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
}

resource "azurerm_role_assignment" "this" {
  for_each             = var.role_assignments
  scope                = each.value.scope
  role_definition_name = each.value.role
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  principal_type       = "ServicePrincipal"
}