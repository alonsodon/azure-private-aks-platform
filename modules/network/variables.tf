variable "name_prefix" {
  description = "Prefix for resource names, e.g. aksplat-dev"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for all network resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "address_space" {
  description = "VNet address space"
  type        = list(string)
}

variable "aks_subnet_prefix" {
  description = "Address prefix of the AKS node subnet"
  type        = string
}

variable "pe_subnet_prefix" {
  description = "Address prefix of the private endpoint subnet"
  type        = string
}

variable "private_dns_zones" {
  description = "Private DNS zones to create and link to the VNet, keyed by a short name"
  type        = map(string)
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}