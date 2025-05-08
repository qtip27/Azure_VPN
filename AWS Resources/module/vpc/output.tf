output "vpc_id" {
   value = aws_vpc.project.id
}

output "cidr_block" {
   value = aws_vpc.project.cidr_block
}