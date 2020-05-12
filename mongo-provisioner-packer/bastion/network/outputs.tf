output "bastion_vpc_id" {
  description = "Id of the newly created Bastion VPC"
  value       = aws_vpc.bastion_vpc.id
}

output "bastion_private_route_table_id" {
  description = "ID of the Bastion VPC route table"
  value       = aws_route_table.private_route_table.id
}

output "bastion_public_route_table_id" {
  description = "ID of the Bastion VPC route table"
  value       = aws_route_table.public_route_table.id
}

output "bastion_private_subnet_id" {
  description = "Id of the newly created subnet for hosting proxies"
  value       = aws_subnet.bastion_private_subnet.id
}

output "bastion_public_subnet_id" {
  description = "Id of the newly created public subnet used for NAT"
  value       = aws_subnet.bastion_public_subnet.id
}

output "bastion_sg_id" {
  description = "Id for Bastion security group."
  value       = aws_security_group.bastion_sg.id
}

output "bastion_private_sg_id" {
  description = "Id for Bastion security group."
  value       = aws_security_group.bastion_private_sg.id
}

