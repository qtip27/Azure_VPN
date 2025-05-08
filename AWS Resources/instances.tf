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
}

#EC2 INSTANCE (NEED TO UPDATE THE USERDATA)

resource "aws_instance" "dev_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  #key_name               = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = [aws_security_group.mtc_sg_2.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id
  user_data              = file("userdata_2.tpl") #(Update the file to install Ansible)

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "dev-node"
  }
}

resource "aws_instance" "worker_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  #key_name               = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id
  user_data              = file("userdata_3.tpl")

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "worker-node"
  }
}

resource "aws_instance" "worker_node_2" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  #key_name               = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet_2.id
  user_data              = file("userdata_3.tpl")

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "worker-node 2"
  }
}*/
