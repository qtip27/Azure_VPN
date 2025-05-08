resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = var.vpc_id  #Referencing the VPC above with the ID of that VPC
  cidr_block              = var.cidr
  map_public_ip_on_launch = var.public
  availability_zone       = var.availability

  tags = {
    Name = var.tag
  }
}