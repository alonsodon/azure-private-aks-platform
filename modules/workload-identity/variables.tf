variable "name" {
  description = "Identity name suffix, e.g. aksplat-dev-demo"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer of the AKS cluster"
  type        = string
}

variable "namespace" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "role_assignments" {
  description = "Roles for this identity, keyed by a short name"
  type = map(object({
    scope = string
    role  = string
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}