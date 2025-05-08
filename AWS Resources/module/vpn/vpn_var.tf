variable "asn" {
  type    = number
}

variable "customer_ip" {
  type    = string
}

variable "customer_id" {
  type    = string
}

variable "transit_id" {
  type    = string
}

variable "shared_key" {
  type    = string
}

variable "vpn_connection" {
  type    = string
  default = null
}