resource "aws_instance" "node" {
  instance_type          = "t2.micro"
  ami                    = var.ami
  #key_name               = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = var.sg_id
  subnet_id              = var.subnet_id 
  user_data              = var.file #file("userdata_2.tpl") #(Update the file to install Ansible)

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "dev-node"
  }
}