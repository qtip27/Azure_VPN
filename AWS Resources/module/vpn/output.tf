output "customer_id" {
   value = aws_customer_gateway.az_customer.id
}

output "transit_id" {
   value = aws_ec2_transit_gateway.azure-gtw.id
}