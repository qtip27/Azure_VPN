variable "vpn_connection" {
  type        = string
  default     = null
}

variable "lng" {
  type        = string
  default     = null
}

variable "name" {
  type        = string
  default     = null
}

variable "location" {
  type        = string
  default     = "centralus"
}

variable "rg_name" {
  type        = string
  default     = null
}

variable "bgp" {
  type        = bool
  default     = null
}

variable "ip_config_name" {
  type        = string
  default     = null
}

variable "shared_key" {
  type        = string
  default     = null
}

variable "public" {
  type        = string
  default     = null
}

variable "fw_public" {
  type        = string
  default     = null
}

variable "subnet" {
  type        = string
  default     = null
}

variable "pub_ip" {
  type        = string
  default     = null
}

variable "kv_name" {
  type        = string
  default     = null
}

variable "tenant" {
  type        = string
  default     = null
}

variable "object" {
  type        = string
  default     = null
}

variable "nsg_name" {
  type        = string
  default     = null
}

variable "subnet_id" {
  type        = string
  default     = null
}

variable "config_subnet_id" {
  type        = string
  default     = null
}

variable "nsg_id" {
  type        = string
  default     = null
}

variable "fw_name" {
  type        = string
  default     = null
}

variable "fw_rule_name" {
  type        = string
  default     = null
}

variable "rt_name" {
  type        = string
  default     = null
}

variable "vpn_peering_name" {
  type        = string
  default     = null
}

variable "vnet_name" {
  type        = string
  default     = null
}

variable "vnet_id" {
  type        = string
  default     = null
}

variable "lng_name" {
  type        = string
  default     = null
}

variable "gw_address" {
  type        = string
  default     = null
}

variable "lng_conn" {
  type        = string
  default     = null
}

variable "type" {
  type        = string
  default     = null
}

variable "ipsec_policy_1" {
  description = "Configuration for IPsec policy"
  type = list(object ({
    sa_lifetime = string
    ipsec_encryption = string
    ipsec_integrity = string
    ike_encryption = string
    ike_integrity = string
    dh_group = string
    pfs_group = string
  }))
  default = null
}

variable "use_policy" {
  type        = bool
  default     = false
}

variable "security_rule" {
  description = "Configuration for NSG"
  type = list(object ({
    name = string
    priority = number
    direction = string
    access = string
    protocol = string
    source_port_range = string
    destination_port_range = string
    source_address_prefix = string
    destination_address_prefix = string
  }))
  default = null
}

variable "rule" {
  description = "Configuration for Firewall"
  type = list(object ({
    name                          = string
    source_addresses              = list(string)
    destination_ports             = list(string)
    destination_addresses         = list(string)
    protocols                     = list(string)
  }))
  default = null
}

variable "east_rg" {
  type        = string
  default     = null
}

variable "east_location" {
  type        = string
  default     = null
}

variable "route_name" {
  type        = string
  default     = null
}

variable "address_prefix" {
  type        = string
  default     = null
}

variable "gw_subnet_id" {
  type        = string
  default     = null
}

variable "routetable_id" {
  type        = string
  default     = null
}

variable "gateway" {
  type        = string
  default     = null
}

variable "connection_mode" {
  type        = string
  default     = null
}

variable "lng_id" {
  type        = string
  default     = null
}

variable "timeout" {
  type        = number
  default     = null
}

variable "hop_address" {
  type        = string
  default     = null
}

variable "user" {
  type        = string
  default     = null
}

variable "custom" {
  type        = string
  default     = null
}

variable "file" {
  type        = string
  default     = null
}

variable "nic_subnet" {
  type        = string
  default     = null
}

variable "secret" {
  type        = string
  default     = null
}

variable "allow_virtual_network_access" {
  type        = bool
}

variable "allow_forwarded_traffic" {
  type        = bool
}

variable "allow_gateway_transit" {
  type        = bool
}

variable "use_remote_gateways" {
  type        = bool
}

variable "ip_configuration" {
  description = "List of rules with their attributes"
  type = list(object({
    name                 = string
    public_ip_address_id     = string
    subnet_id    = string
    private_ip_address_allocation = string
  }))
  default = null
}