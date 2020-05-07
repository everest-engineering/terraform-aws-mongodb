output "ebs-vol-id" {
  value = aws_ebs_volume.mongo-data-vol.id
}

output "availability_zone" {
  value = aws_ebs_volume.mongo-data-vol.availability_zone
}