resource "aws_ecs_cluster" "mongo_ecs" {
  name = var.name

  tags = var.tags
}

resource "aws_ecs_task_definition" "mongo-task" {
  container_definitions    = data.template_file.container_definition.rendered
  family                   = var.name
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  volume {
    name = var.name

    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
      driver        = "rexray/ebs"

      driver_opts = {
        volumetype = var.ebs_volume_type
        size       = var.ebs_volume_size
      }
    }
  }
  tags = var.tags
}

resource "aws_ecs_service" "mongodb-ecs-service" {
  name                               = var.name
  cluster                            = aws_ecs_cluster.mongo_ecs.arn
  task_definition                    = aws_ecs_task_definition.mongo-task.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  launch_type                        = "EC2"
}

data "template_file" "container_definition" {
  template = file("${path.module}/container-definitions/mongo.tpl")

  vars = {
    mongo_version          = var.mongo_version
    mongo_container_cpu    = var.mongo_container_cpu
    mongo_container_memory = var.mongo_container_memory
    volume_name            = var.name
  }
}