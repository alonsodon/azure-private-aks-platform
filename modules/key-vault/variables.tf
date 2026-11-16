variable "name" {
  description = "Base name; a random suffix is appended (max 18 characters)"
  type        = string

  validation {
    condition     = length(var.name) <= 18
    error_message = "name must be at most 18 characters (Key Vault names are limited to 24)."
  }
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  description = "Entra ID tenant that issues tokens for this vault"
  type        = string
}

variable "allowed_ip_cidrs" {
  description = "Public IPs allowed through the vault firewall (deployers)"
  type        = list(string)
  default     = []
}

variable "pe_subnet_id" {
  description = "Subnet for the private endpoint"
  type        = string
}

variable "private_dns_zone_id" {
  description = "ID of privatelink.vaultcore.azure.net"
  type        = string
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
}

variable "purge_protection_enabled" {
  type    = bool
  default = false
}

variable "secret_name" {
  description = "Name of the demo secret"
  type        = string
  default     = "mysql-connection-string"
}

variable "mysql_host" {
  description = "Host written into the demo connection string"
  type        = string
  default     = "mysql.demo.internal"
}

variable "secret_version" {
  description = "Increase to generate and write a new password (write-only rotation)"
  type        = number
  default     = 1
}

variable "tags" {
  type    = map(string)
  default = {}
}