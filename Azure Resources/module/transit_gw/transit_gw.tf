data "azurerm_key_vault_secret" "vpn_secret" {
  name         = var.secret 
  key_vault_id = azurerm_key_vault.vpn_key.id
}

resource "azurerm_virtual_network_gateway" "aws" {
  name                = var.name 
  location            = var.location 
  resource_group_name = var.rg_name 

  type     = var.type 
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = var.bgp 
  sku           = "VpnGw1AZ"

  dynamic "ip_configuration" {
    for_each = var.ip_configuration
    content {
      name = ip_configuration.value.name
      public_ip_address_id = ip_configuration.value.public_ip_address_id
      subnet_id = ip_configuration.value.subnet_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
    }
  }  
}

resource "azurerm_public_ip" "aws_vpn" {
  name                = var.pub_ip 
  resource_group_name = var.rg_name 
  location            = var.location 
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_key_vault" "vpn_key" {
  name                        = var.kv_name 
  location                    = var.location 
  resource_group_name         = var.rg_name 
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant 
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant 
    object_id = var.object 


    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]
  }
}

resource "azurerm_key_vault_secret" "ipsec" {
  name         = "TunnelKey"
  value        = "xxxxxxxxxxxxxxxz"
  key_vault_id = azurerm_key_vault.vpn_key.id
}


resource "azurerm_network_security_group" "vpn_nsg" {
  name                = var.nsg_name 
  location            = var.location 
  resource_group_name = var.rg_name 

  dynamic "security_rule" {
    for_each = var.security_rule
    content {
    name                       = security_rule.value.name
    priority                   = security_rule.value.priority
    direction                  = security_rule.value.direction
    access                     = security_rule.value.access
    protocol                   = security_rule.value.protocol
    source_port_range          = security_rule.value.source_port_range
    destination_port_range     = security_rule.value.destination_port_range
    source_address_prefix      = security_rule.value.source_address_prefix
    destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_firewall" "aws_vpn" {
  name                = var.fw_name 
  location            = var.location 
  resource_group_name = var.rg_name 
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.config_subnet_id 
    public_ip_address_id = var.fw_public 
  }
}

resource "azurerm_firewall_network_rule_collection" "aws_vpn" {
  name                = var.fw_rule_name
  azure_firewall_name = var.fw_name 
  resource_group_name = var.rg_name 
  priority            = 100
  action              = "Allow"

  dynamic "rule" {
    for_each = var.rule
    content {
    name                          = rule.value.name 
    source_addresses              = rule.value.source_addresses
    destination_ports             = rule.value.destination_ports
    destination_addresses         = rule.value.destination_addresses
    protocols                     = rule.value.protocols
    }
  }
}

resource "azurerm_route_table" "vpn_route" {
  name                = var.rt_name 
  location            = var.location 
  resource_group_name = var.rg_name 

  route {
    name           = var.route_name 
    address_prefix = var.address_prefix 
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = var.hop_address
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_route_table_association" "fw_assoc" { 
  subnet_id      = var.gw_subnet_id
  route_table_id = var.routetable_id 
}

resource "azurerm_virtual_network_peering" "vpn_peering" {
  name                         = var.vpn_peering_name 
  resource_group_name          = var.rg_name 
  virtual_network_name         = var.vnet_name 
  remote_virtual_network_id    = var.vnet_id 
  allow_virtual_network_access = var.allow_virtual_network_access 
  allow_forwarded_traffic      = var.allow_forwarded_traffic 
  allow_gateway_transit        = var.allow_gateway_transit 
  use_remote_gateways          = var.use_remote_gateways 
}

resource "azurerm_local_network_gateway" "aws_local" {
  count = var.lng == "true" ? 1 : 0
  name                = var.lng_name 
  resource_group_name = var.rg_name 
  location            = var.location 
  gateway_address     = var.gw_address 
  address_space       = ["", ""] #IP Addresses of AWS or On-Premise
}

resource "azurerm_virtual_network_gateway_connection" "aws_connection" {
  count = var.vpn_connection == "true" ? 1 : 0
  name                = var.lng_conn 
  location            = var.location 
  resource_group_name = var.rg_name 

  type                            = "IPsec"
  virtual_network_gateway_id      = var.gateway 
  shared_key = data.azurerm_key_vault_secret.vpn_secret.value 
  enable_bgp = false
  connection_mode = var.connection_mode
  local_network_gateway_id = var.lng_id
  dpd_timeout_seconds = var.timeout
  depends_on = [azurerm_local_network_gateway.aws_local]
  
  dynamic "ipsec_policy" {
    for_each = var.use_policy ? [var.ipsec_policy_1] : []
    content {
      sa_lifetime = ipsec_policy.value.sa_lifetime
      ipsec_encryption = ipsec_policy.value.ipsec_encryption
      ipsec_integrity = ipsec_policy.value.ipsec_integrity
      ike_encryption = ipsec_policy.value.ike_encryption
      ike_integrity = ipsec_policy.value.ike_integrity
      dh_group = ipsec_policy.value.dh_group
      pfs_group = ipsec_policy.value.pfs_group
    }
  }  
}

resource "azurerm_virtual_network" "east-vnet" {
  name                = "east-network"
  resource_group_name = var.east_rg 
  location            = var.east_location 
  address_space       = [""]

  tags = {
    environment = "east-us"
  }
}

resource "azurerm_subnet" "east-subnet" {
  name                 = "east-us-subnet"
  resource_group_name = var.east_rg 
  virtual_network_name = azurerm_virtual_network.east-vnet.name
  address_prefixes     = [""]
}

resource "azurerm_linux_virtual_machine" "east_vm" {
  name                = "East-Machine"
  resource_group_name = var.east_rg 
  location            = var.east_location 
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.east_nic.id,
  ]

  custom_data = var.custom #filebase64("customdata.tpl")

  admin_ssh_key {
    username   = var.user 
    public_key = var.file #file("~/.ssh/hunterazurekey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "east_nic" {
  name                = "article-lin-nic"
  resource_group_name = var.east_rg 
  location            = var.east_location 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.nic_subnet
    private_ip_address_allocation = "Dynamic"
    }

  tags = {
    environment = "dev"
  }
}
