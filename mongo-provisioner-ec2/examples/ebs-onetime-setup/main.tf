provider "aws" {
  region  = "us-east-1"
}

resource "aws_ebs_volume" "mongo-data-vol" {
  availability_zone = var.availability_zone
  type              = "gp2"
  size              = var.volume_size

  tags = {
    Name        = "mongo-data-ebs-volume"
    Environment = var.environment_tag
  }
}