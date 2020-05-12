
output "vpc-id" {
  value = aws_vpc.my_vpc.id
}

output "ebs-vol-id" {
  value = aws_ebs_volume.mongo-data-vol.id
}

output "availability_zone" {
  value = aws_ebs_volume.mongo-data-vol.availability_zone
}

output "bastion_host" {
  value = aws_instance.my_bastion_host.public_ip
}

output "public_subnet_id" {
  value = aws_subnet.my_public_subnet_1.id
}

output "private_subnet_id" {
  value = aws_subnet.my_private_subnet_1.id
}
