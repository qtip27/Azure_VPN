# output "dev_ip" {
#   value = aws_instance.dev_node.public_ip
# }

output "sg_id" {
   value = aws_security_group.mtc_sg.id
}