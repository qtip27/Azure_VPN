module "vpn_tunnel" {
  source     = "./module/vpn"
  #AWS Transit Gateway
  asn = "64512"

  #Customer Gateway
  customer_ip = "130.131.176.158" #IP Address from Azure VNG

  #VPN Connetion
  vpn_connection = false
  customer_id = module.vpn_tunnel.customer_id
  transit_id = module.vpn_tunnel.transit_id
  shared_key = "Nz4NP7zsd57sVVZghTak"

}