variable "name_prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  description = "Entra ID tenant for cluster authentication"
  type        = string
}

variable "subnet_id" {
  description = "AKS node subnet"
  type        = string
}

variable "kubernetes_version" {
  description = "null = AKS default version (pin it in production)"
  type        = string
  default     = null
}

variable "node_vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "os_disk_size_gb" {
  type    = number
  default = 64
}

variable "pod_cidr" {
  type = string
}

variable "service_cidr" {
  type = string
}

variable "dns_service_ip" {
  type = string
}

variable "authorized_ip_ranges" {
  description = "Public IPs allowed to reach the API server (D18)"
  type        = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}