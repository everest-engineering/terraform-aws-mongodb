output "id" {
  description = "List of IDs of instances"
  value       = aws_instance.mongodb.*.id
}

output "arn" {
  description = "List of ARNs of instances"
  value       = aws_instance.mongodb.*.arn
}

output "key_name" {
  description = "List of key names of instances"
  value       = aws_instance.mongodb.*.key_name
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = aws_instance.mongodb.*.public_ip
}

output "security_groups" {
  description = "List of associated security groups of instances"
  value       = aws_instance.mongodb.*.security_groups
}

output "vpc_security_group_ids" {
  description = "List of associated security groups of instances, if running in non-default VPC"
  value       = aws_instance.mongodb.*.vpc_security_group_ids
}

output "subnet_id" {
  description = "List of IDs of VPC subnets of instances"
  value       = aws_instance.mongodb.*.subnet_id
}

output "instance_state" {
  description = "List of instance states of instances"
  value       = aws_instance.mongodb.*.instance_state
}

output "tags" {
  description = "List of tags of instances"
  value       = aws_instance.mongodb.*.tags
}
