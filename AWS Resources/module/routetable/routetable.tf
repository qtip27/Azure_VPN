#ROUTING TABLE ASSOC.
resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id 

  tags = {
    Name = var.tag 
  }
}

resource "aws_route" "route" {
  route_table_id         = var.route_id 
  destination_cidr_block = var.cidr 
  gateway_id             = var.gateway 
}

resource "aws_route_table_association" "assoc" {
  subnet_id      = var.subnet 
  route_table_id = var.route_tbl_id 
}