output "nsg_id" {
  value       = azurerm_network_security_group.vpn_nsg.id
}

output "public_ip" {
  value       = azurerm_public_ip.aws_vpn.id
}

output "vnet_id" {
  value       = azurerm_virtual_network.east-vnet.id
}

output "kv_id" {
  value       = azurerm_key_vault.vpn_key.id
}

output "route_id" {
  value       = azurerm_route_table.vpn_route.id
}

output "gw_id" {
  value       = azurerm_virtual_network_gateway.aws.id
}

output "private" {
  value       = azurerm_firewall.aws_vpn.ip_configuration[0].private_ip_address 
}

output "east_subnet" {
  value       = azurerm_subnet.east-subnet.id 
}

output "east_vnet" {
  value       = azurerm_virtual_network.east-vnet.name 
}

output "east_vnet_name" {
  value       = azurerm_virtual_network.east-vnet.name
}

output "local_id" {
  value       = azurerm_local_network_gateway.aws_local[0].id
}
