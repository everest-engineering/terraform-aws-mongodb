provider "aws" {
  region = "ap-southeast-1"
  version = "2.60.0"
}

module "mongo_ecs_ec2_cluster" {
  source = "../"

  security_group_id = aws_security_group.mongo-ecs-security-group.id
  subnet_id = module.dynamic-subnets.private_subnet_ids[0]
  ebs_volume_size = 5
  ebs_volume_type = "gp2"
  instance_type = "t3.medium"
  name = "mongo"
  region = "ap-southeast-1"
  stage = "Development"
  mongo_container_cpu = 512
  mongo_container_memory = 1024
  mongo_version = "4.0"

  tags = {
    Environment = "Development"
    TF-Managed = true
  }
}