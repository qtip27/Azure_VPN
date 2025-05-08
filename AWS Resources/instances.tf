#########################################################
#         Development EC2 Instances
#########################################################

module "ec2_instance_dev" {
  source     = "./module/ec2"
  ami = data.aws_ami.server_ami.id
  sg_id = [module.security_group_dev.sg_id]
  subnet_id = module.subnet_public.subnet_id
  file = file("userdata_2.tpl") #(Update the file to install Ansible)
}

module "ec2_instance_worker" {
  source     = "./module/ec2"
  ami = data.aws_ami.server_ami.id
  sg_id = [module.security_group_dev.sg_id]
  subnet_id = module.subnet_public.subnet_id
  file = file("userdata_3.tpl") #(Update the file to install Ansible)
}

module "ec2_instance_second_worker" {
  source     = "./module/ec2"
  ami = data.aws_ami.server_ami.id
  sg_id = [module.security_group_dev.sg_id]
  subnet_id = module.subnet_public.subnet_id
  file = file("userdata_3.tpl") #(Update the file to install Ansible)
}

####################################################################################
#                         Production EC2 Intances
####################################################################################

module "ec2_instance_prod" {
  source     = "./module/ec2"
  ami = data.aws_ami.server_ami.id
  sg_id = [module.security_group_prod.sg_id]
  subnet_id = module.subnet_public_prod.subnet_id
  file = file("userdata_2.tpl") #(Update the file to install Ansible)
}

module "ec2_instance_worker_prod" {
  source     = "./module/ec2"
  ami = data.aws_ami.server_ami.id
  sg_id = [module.security_group_prod.sg_id]
  subnet_id = module.subnet_public_prod.subnet_id
  file = file("userdata_3.tpl") #(Update the file to install Ansible)
}

module "ec2_instance_second_worker_prod" {
  source     = "./module/ec2"
  ami = data.aws_ami.server_ami.id
  sg_id = [module.security_group_prod.sg_id]
  subnet_id = module.subnet_public_prod.subnet_id
  file = file("userdata_3.tpl") #(Update the file to install Ansible)
}

#KEY PAIR
/*resource "aws_key_pair" "mtc_auth" {
  key_name   = "mtckey"
  public_key = file("~/.ssh/mtckey.pub") #(Create the Config File)
}*/
