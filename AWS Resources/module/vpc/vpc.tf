resource "aws_vpc" "project" {
  cidr_block           = var.ip_address
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.tags
  }
}