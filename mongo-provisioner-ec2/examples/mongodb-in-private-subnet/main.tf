provider "aws" {
  region  = "us-east-1"
  profile = "terraform-provisioner-ansible"
}

module "mongodb" {
  source            = "../../"
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  instance_type     = "t2.micro"
  ami_filter_name   = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  ebs_volume_id     = var.ebs_volume_id
  availability_zone = var.availability_zone
  mongodb_version   = "4.2"
  private_key       = file("~/.ssh/id_rsa")
  public_key        = file("~/.ssh/id_rsa.pub")
  bastion_host      = var.bastion_host
  environment_tag   = "terraform-mongo-test"
}

variable "availability_zone" {
  type = string
  description = "Availability zone in which MongoDB should be provisioned"
  default = "us-east-1a"
}

variable "vpc_id" {
  type = string
  description = "VPC Id"
}

variable "subnet_id" {
  type = string
  description = "Subnet Id"
}

variable "ebs_volume_id" {
  type = string
  description = "EBS Volume Id"
}

variable "bastion_host" {
  type = string
  description = "Bastion host Public IP"
}

output "mongo_server_ip_address" {
  value = module.mongodb.mongo_server_private_ip
}

