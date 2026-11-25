resource "azurerm_user_assigned_identity" "pipeline" {
  name                = "id-${var.project}-github"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  tags                = local.tags
}

# Which GitHub tokens Entra ID accepts for this identity (D21)
locals {
  github_subjects = {
    pull-request = "repo:${var.github_oidc_subject_repo}:pull_request"         # plan on pull requests
    env-dev      = "repo:${var.github_oidc_subject_repo}:environment:dev"      # apply to dev
    env-dev-plan = "repo:${var.github_oidc_subject_repo}:environment:dev-plan" # plan on main, no approval
    env-prod     = "repo:${var.github_oidc_subject_repo}:environment:prod"     # plan for prod, with approval
  }
}

resource "azurerm_federated_identity_credential" "github" {
  for_each                  = local.github_subjects
  name                      = "github-${each.key}"
  user_assigned_identity_id = azurerm_user_assigned_identity.pipeline.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = each.value
}

# Roles the pipeline may hand out, and no others (D26)
data "azurerm_role_definition" "delegable" {
  for_each = toset([
    "Key Vault Secrets User",        # app identity reads the secret
    "Network Contributor",           # AKS control plane identity on its subnet
    "Storage Blob Data Contributor", # app identity on the app storage
  ])
  name = each.value
}

locals {
  # The condition needs bare GUIDs: basename() takes the last segment of the role definition ID
  delegable_role_ids = join(", ", [for r in data.azurerm_role_definition.delegable : basename(r.id)])

  rbac_condition = <<-EOT
    (
     (
      !(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})
     )
     OR
     (
      @Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.delegable_role_ids}}
     )
    )
    AND
    (
     (
      !(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})
     )
     OR
     (
      @Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.delegable_role_ids}}
     )
    )
  EOT
}

resource "azurerm_role_assignment" "pipeline_contributor" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.pipeline.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "pipeline_rbac_admin" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = azurerm_user_assigned_identity.pipeline.principal_id
  principal_type       = "ServicePrincipal"
  condition            = local.rbac_condition
  condition_version    = "2.0"
}

resource "azurerm_role_assignment" "pipeline_kv_officer" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.pipeline.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "pipeline_state" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.pipeline.principal_id
  principal_type       = "ServicePrincipal"
}
