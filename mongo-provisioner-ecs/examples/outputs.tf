output "public_ip" {
  value = module.mongo_ecs_ec2_cluster.mongo_instance_public_ip
}

output "private_ip" {
  value = module.mongo_ecs_ec2_cluster.mongo_instance_private_ip
}

output "cluster_name" {
  value = module.mongo_ecs_ec2_cluster.ecs_cluster_name
}

output "cluster_region" {
  value = module.mongo_ecs_ec2_cluster.ecs_cluster_region
}