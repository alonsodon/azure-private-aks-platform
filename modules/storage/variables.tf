variable "name" {
  description = "Base name, lowercase letters and digits; a random suffix is appended (max 19 characters)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,19}$", var.name))
    error_message = "name must be 3-19 lowercase letters or digits (storage names are limited to 24)."
  }
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "public_network_access_enabled" {
  description = "false = reachable only through the private endpoint (D37)"
  type        = bool
  default     = false
}

variable "allowed_ip_cidrs" {
  description = "Used only if public access is enabled (plan B)"
  type        = list(string)
  default     = []
}

variable "container_names" {
  type    = list(string)
  default = ["app-data"]
}

variable "pe_subnet_id" {
  type = string
}

variable "private_dns_zone_id" {
  description = "ID of privatelink.blob.core.windows.net"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}