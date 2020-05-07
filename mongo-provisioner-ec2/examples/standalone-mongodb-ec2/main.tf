provider "aws" {
  region  = "us-east-1"
  profile = "terraform-provisioner-ansible"
}

locals {
  availability_zone = "us-east-1a"
  ebs_volume_id     = "YOUR_VOLUME_ID"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "subnet" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = local.availability_zone
}

module "mongodb" {
  source = "../../"
  vpc_id = data.aws_vpc.default.id
  subnet_id = data.aws_subnet.subnet.id
  instance_type     = "t2.micro"
  ami_filter_name   = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  ebs_volume_id     = local.ebs_volume_id
  availability_zone = local.availability_zone
  volume_size       = "8"
  mongodb_version   = "4.0"
  private_key       = file("~/.ssh/id_rsa")
  public_key        = file("~/.ssh/id_rsa.pub")
  environment_tag   = "terraform-mongo-test"
}

output "mongo_server_public_ip" {
  value = module.mongodb.mongo_server_public_ip
}

output "mongo_connect_url" {
  value = module.mongodb.mongo_connect_url
}
