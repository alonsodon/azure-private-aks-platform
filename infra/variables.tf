variable "subscription_id" {
  description = "Target subscription (git-ignored local tfvars or TF_VAR_subscription_id)"
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group (provided by PRODYNA)"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
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

variable "environment" {
  description = "Stage name"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be dev or prod."
  }
}

variable "address_space" {
  description = "VNet address space"
  type        = list(string)
}

variable "aks_subnet_prefix" {
  description = "AKS node subnet"
  type        = string
}

variable "pe_subnet_prefix" {
  description = "Private endpoint subnet"
  type        = string
}

variable "allowed_ip_cidrs" {
  description = "Deployer public IPs for the Key Vault firewall (git-ignored local tfvars)"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.allowed_ip_cidrs : can(cidrhost(c, 0))])
    error_message = "Each entry must be a CIDR, e.g. 203.0.113.10/32."
  }
}

variable "kv_soft_delete_retention_days" {
  description = "Key Vault soft delete retention (7-90 days)"
  type        = number
  default     = 7
}

variable "kv_purge_protection_enabled" {
  description = "Key Vault purge protection (true in production)"
  type        = bool
  default     = false
}

variable "storage_public_network_access_enabled" {
  description = "Storage public access; false = private endpoint only (D37)"
  type        = bool
  default     = false
}