output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

# Taken from the association so consumers wait until the NSG is attached
output "pe_subnet_id" {
  value = azurerm_subnet_network_security_group_association.private_endpoints.subnet_id
}

# Taken through the links so private endpoints are created after the zones are linked
output "private_dns_zone_ids" {
  value = { for k, link in azurerm_private_dns_zone_virtual_network_link.this : k => azurerm_private_dns_zone.this[k].id }
}