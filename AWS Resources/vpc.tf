##########################################################
#             Development
##########################################################

module "vpc" {
  source     = "./module/vpc"
  ip_address = ""
  tags       = "Dev"
}

module "subnet_public" {
  source     = "./module/subnet"
  vpc_id = module.vpc.vpc_id
  cidr = ""
  public = true
  availability = "us-east-2a"
  tag       = "dev-public-1"
}

module "subnet_private" {
  source     = "./module/subnet"
  vpc_id = module.vpc.vpc_id
  cidr = ""
  availability = "us-east-2a"
  tag       = "dev-private-1"
}

module "subnet_public_1" {
  source     = "./module/subnet"
  vpc_id = module.vpc.vpc_id
  cidr = ""
  public = true
  availability = "us-east-2a"
  tag       = "dev-public-2"
}

module "subnet_private_1" {
  source     = "./module/subnet"
  vpc_id = module.vpc.vpc_id
  cidr = ""
  availability = "us-east-2a"
  tag       = "dev-private-2"
}

module "internet_gateway_dev" {
  source     = "./module/igw"
  vpc_id = module.vpc.vpc_id
  tag       = "dev-igw"
}

module "routetable_dev" {
  source     = "./module/routetable"
  vpc_id = module.vpc.vpc_id
  tag       = "dev-rtb"
  route_id = "${module.routetable_dev.rt_id}"
  cidr = "0.0.0.0/0"
  gateway = module.internet_gateway_dev.igw_id
  subnet = module.subnet_public.subnet_id
  route_tbl_id = module.routetable_dev.rt_id
}

#######################################################################
#               Production
#######################################################################

module "vpc_prod" {
  source     = "./module/vpc"
  ip_address = ""
  tags       = "Prod"
}

module "subnet_public_prod" {
  source     = "./module/subnet"
  vpc_id = module.vpc_prod.vpc_id
  cidr = ""
  public = true
  availability = "us-east-2a"
  tag       = "dev-public-100"

  # #Load Balancer
  # lb = "prod-mtc-lb-tf"
  # subnets = ["${module.subnet_public_prod.subnet_id}"]
  # tags = "Production"
}

module "subnet_private_prod" {
  source     = "./module/subnet"
  vpc_id = module.vpc_prod.vpc_id
  cidr = ""
  availability = "us-east-2a"
  tag       = "dev-private-101"
}

module "internet_gateway_prod" {
  source     = "./module/igw"
  vpc_id = module.vpc_prod.vpc_id
  tag       = "prod-igw"
}

module "routetable_prod" {
  source     = "./module/routetable"
  vpc_id = module.vpc_prod.vpc_id
  tag       = "dev-rtb"
  route_id = "${module.routetable_prod.rt_id}"
  cidr = "0.0.0.0/0"
  gateway = module.internet_gateway_prod.igw_id
  subnet = module.subnet_public_prod.subnet_id
  route_tbl_id = module.routetable_prod.rt_id
}

#Load Balancer
resource "aws_lb" "mtc_load_balancer" {
  name               = "mtc-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [module.subnet_public.subnet_id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}
