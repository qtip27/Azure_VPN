module "aws_vpn" {
  source = "./module/transit_gw"
  rg_name = azurerm_resource_group.article.name
  location = "centralus"
  #Gateway
  name = "aws-transit-gateway"  
  type = "Vpn"
  bgp = false
  ip_configuration = [
    {
      name =  "awsGatewayConfig"
      public_ip_address_id     = azurerm_public_ip.gateway_ip.id
      subnet_id    = azurerm_subnet.gw_subnet.id
      private_ip_address_allocation = "Dynamic"
    },
    {
      name =  "Second_IP"
      public_ip_address_id     = azurerm_public_ip.gw-sec-ip.id
      subnet_id    = azurerm_subnet.gw_subnet.id
      private_ip_address_allocation = "Dynamic"
    }
  ]

  #Public IP
  pub_ip = "VPN-public"

  #Key Vault
  kv_name = "article-vpn-kv"
  tenant = data.azurerm_client_config.current.tenant_id
  object = data.azurerm_client_config.current.object_id

  #East US Vnet 
  east_rg = data.azurerm_resource_group.east.name
  east_location = "eastus"

  #Network Security Group
  nsg_name = "VPN-nsg"
  security_rule = [
    {
      name                       = "article-lin"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    },
    {
      name                       = "article-win"
      priority                   = 205
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }, 
    {
      name                       = "article-deny"
      priority                   = 210
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*" 
    },
    {
      name                       = "article-out"
      priority                   = 200
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "443"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    },
    {
      name                       = "article-out-deny"
      priority                   = 210
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    }
  ]

  #NSG Association
  # subnet_id = azurerm_subnet.article-subnet.id
  # nsg_id = module.aws_vpn.nsg_id

  #Firewall w/ Rules
  fw_name = "Azure-Firewall"
  fw_public = module.aws_vpn.public_ip
  config_subnet_id = azurerm_subnet.fw_subnet.id

  fw_rule_name = "AzureRules"
  rule = [
    {
      name = "aws_rule1"
      source_addresses = ["",]
      destination_ports = ["443","80",]
      destination_addresses = ["","",]
      protocols = ["TCP"]
    },
    {
      name = "aws_rule2"
      source_addresses = ["","",]
      destination_ports = ["443","80",]
      destination_addresses = ["",]
      protocols = ["TCP"]
    }
  ]

  #Route Table
  rt_name = "Vnet-Route"
  route_name = "vpn_route"
  address_prefix = ""
  hop_address = module.aws_vpn.private

  #Route Table Assoc.
  gw_subnet_id = azurerm_subnet.gw_subnet.id
  routetable_id = module.aws_vpn.route_id

  #Peering
  vpn_peering_name = "Vnet-Peering"
  vnet_name = azurerm_virtual_network.article-vnet.name
  vnet_id = module.aws_vpn.vnet_id
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = true
  use_remote_gateways          = false

  #Local Network Gateway 
  lng = false
  lng_name = "AWS-Local"
  gw_address = "" #Local IP of AWS

  #Local Connection
  vpn_connection = false
  lng_conn = "Azure-AWS"
  secret = "TunnelKey"
  gateway = module.aws_vpn.gw_id
  connection_mode = "Default"
  lng_id = module.aws_vpn.local_id
  timeout = 45  

  #East US VM
  custom = filebase64("customdata.tpl")
  user = "adminuser"
  file = file("~/.ssh/hunterazurekey.pub")
  nic_subnet = module.aws_vpn.east_subnet
}
