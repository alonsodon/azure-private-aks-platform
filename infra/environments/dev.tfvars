environment       = "dev"
address_space     = ["10.0.0.0/16"]
aks_subnet_prefix = "10.0.0.0/22"
pe_subnet_prefix  = "10.0.4.0/24"

kv_soft_delete_retention_days = 7
kv_purge_protection_enabled   = false

aks_pod_cidr       = "192.168.0.0/16"
aks_service_cidr   = "172.16.0.0/16"
aks_dns_service_ip = "172.16.0.10"