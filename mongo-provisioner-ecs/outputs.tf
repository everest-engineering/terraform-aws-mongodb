output "mongo_instance_ip" {
  value = aws_instance.mongo-ecs-instance.private_ip
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.mongo_ecs.arn
}