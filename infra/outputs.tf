output "key_vault_name" {
  value = module.key_vault.name
}

output "key_vault_private_ip" {
  value = module.key_vault.private_ip
}

output "storage_account_name" {
  value = module.storage.name
}

output "storage_private_ip" {
  value = module.storage.private_ip
}

output "aks_subnet_id" {
  value = module.network.aks_subnet_id
}

output "aks_name" {
  value = module.aks.name
}

output "demo_client_id" {
  value = module.demo_identity.client_id
}