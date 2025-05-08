variable "name" {
  type    = string
}

variable "vpc_id" {
  type    = string
}

variable "ingress" {
  description = "A list of security group rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = null
}

variable "egress" {
  description = "A list of security group rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = null
}