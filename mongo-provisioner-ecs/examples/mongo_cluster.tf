provider "aws" {
  region  = "ap-southeast-1"
  version = "2.60.0"
}

module "mongo_ecs_ec2_cluster" {
  source = "../"

  //Creating DB cluster in public subnet is not recommended in production.
  subnet_id              = module.dynamic-subnets.public_subnet_ids[0]
  security_group_id      = aws_security_group.mongo-ecs-security-group.id
  ebs_volume_size        = 5
  ebs_volume_type        = "gp2"
  instance_type          = "t3.medium"
  name                   = "test-mongo"
  region                 = "ap-southeast-1"
  stage                  = "Development"
  mongo_container_cpu    = 512
  mongo_container_memory = 1024
  mongo_version          = "latest" //Version tag of mongo docker image


  tags = {
    Environment = "Development"
    TF-Managed  = true
  }
}