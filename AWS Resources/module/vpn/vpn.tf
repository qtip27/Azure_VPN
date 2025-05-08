resource "aws_ec2_transit_gateway" "azure-gtw" {
  description = "AWS Transit Gateway to Azure"
  amazon_side_asn = var.asn
}

resource "aws_customer_gateway" "az_customer" {
  bgp_asn = 65000
  ip_address = var.customer_ip #
  type       = "ipsec.1"

  tags = {
    Name = "main-customer-gateway"
  }
}

resource "aws_vpn_connection" "tunnel" {
  count = var.vpn_connection == "true" ? 1 : 0
  customer_gateway_id                     = var.customer_id
  transit_gateway_id                      = var.transit_id 
  type                                    = "ipsec.1"
  static_routes_only                      = true
  tunnel1_preshared_key                   = var.shared_key

  tags = {
    Name = "terraform_ipsec_vpn_example"
  }
}