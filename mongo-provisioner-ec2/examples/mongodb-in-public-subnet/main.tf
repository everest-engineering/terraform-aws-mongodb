provider "aws" {
  region  = "us-east-1"
  profile = "terraform-provisioner-ansible"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "subnet" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = var.availability_zone
}

module "mongodb" {
  source            = "../../"
  vpc_id            = data.aws_vpc.default.id
  subnet_id         = data.aws_subnet.subnet.id
  ssh_user          = "ubuntu"
  instance_type     = "t2.micro"
  ami_filter_name   = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  ami_owners        = ["099720109477"]
  ebs_volume_id     = var.ebs_volume_id
  availability_zone = var.availability_zone
  mongodb_version   = "4.2"
  private_key       = file("~/.ssh/id_rsa")
  public_key        = file("~/.ssh/id_rsa.pub")
  tags = {
    Name        = "MongoDB Server"
    Environment = "terraform-mong-testing"
  }

}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "ebs_volume_id" {
  type        = string
  description = "EBS Volume Id"
}

output "mongo_server_ip_address" {
  value = module.mongodb.mongo_server_public_ip
}
