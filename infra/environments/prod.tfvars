environment       = "prod"
address_space     = ["10.1.0.0/16"] # no overlap with dev: ready to peer into a hub later
aks_subnet_prefix = "10.1.0.0/22"
pe_subnet_prefix  = "10.1.4.0/24"

aks_pod_cidr       = "192.168.0.0/16" # overlay pod IPs never leave the cluster, so they can repeat per cluster
aks_service_cidr   = "172.16.0.0/16"
aks_dns_service_ip = "172.16.0.10"
aks_node_count     = 2

kv_soft_delete_retention_days = 90
kv_purge_protection_enabled   = true