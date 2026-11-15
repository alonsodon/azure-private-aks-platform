variable "subscription_id" {
  description = "Target subscription (set in the git-ignored local tfvars file)"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f-]{36}$", var.subscription_id))
    error_message = "subscription_id must be a GUID."
  }
}

variable "resource_group_name" {
  description = "Existing resource group to deploy into (provided by PRODYNA)"
  type        = string
}

variable "location" {
  description = "Azure region for the bootstrap resources"
  type        = string
  default     = "westeurope"
}

variable "project" {
  description = "Short project name used in resource names"
  type        = string
  default     = "aksplat"

  validation {
    condition     = can(regex("^[a-z0-9]{3,10}$", var.project))
    error_message = "project must be 3-10 lowercase letters or digits."
  }
}

variable "github_repository" {
  description = "GitHub repository allowed to deploy, as owner/name"
  type        = string
  default     = "alonsodon/azure-private-aks-platform"
}

variable "create_budget" {
  description = "Create a budget on the resource group"
  type        = bool
  default     = true
}

variable "budget_amount" {
  description = "Monthly budget for the resource group"
  type        = number
  default     = 50
}

variable "budget_start_date" {
  description = "First day of the budget period (first day of a month, RFC 3339)"
  type        = string
  default     = "2026-11-01T00:00:00Z"
}

variable "alert_emails" {
  description = "Budget alert recipients (set in the git-ignored local tfvars file)"
  type        = list(string)
  default     = []
}
