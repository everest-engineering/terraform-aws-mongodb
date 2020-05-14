variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "subnet_id" {
  type        = string
  description = "Subnet Id"
}

variable "instance_type" {
  type        = string
  description = "AWS EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  type        = string
  description = "AWS AMI Id"
  default     = ""
}

variable "ami_filter_name" {
  type        = string
  description = "AWS AMI Name filter value"
  default     = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
}

variable "ebs_volume_id" {
  type        = string
  description = "Id of the EBS volume."
}

variable "availability_zone" {
  type        = string
  description = "Availability zone"
}

variable "mongodb_version" {
  type        = string
  description = "MongoDB version"
  default     = "4.2"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}

variable "public_key" {
  type        = string
  description = "Public keypair name"
}

variable "private_key" {
  type        = string
  description = "Private key"
}

variable "bastion_host" {
  type        = string
  description = "Bastion host IP"
  default     = ""
}

variable "ami_owners" {
  type        = list(string)
  description = "AMI owners filter"
  default     = ["self", "amazon", "aws-marketplace"]
}

variable "ssh_user" {
  type        = string
  description = "SSH user name"
}