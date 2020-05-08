//TODO: Prasanna - Remove this output after finding a better testing strategy
output "mongo_instance_public_ip" {
  value = aws_instance.mongo-ecs-instance.public_ip
}

output "mongo_instance_private_ip" {
  value = aws_instance.mongo-ecs-instance.private_ip
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.mongo_ecs.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.mongo_ecs.name
}

output "ecs_cluster_region" {
  value = var.region
}