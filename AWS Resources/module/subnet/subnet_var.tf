variable "vpc_id" {
  type    = string
}

variable "cidr" {
  type    = string
}

variable "public" {
  type    = bool
  default = false
}

variable "availability" {
  type    = string
}

variable "tag" {
  type    = string
}