variable "vpc_cidr" {
  type = string
  description = "CIDR block for VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type = string
  description = "CIDR block for Public Subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type = string
  description = "CIDR block for Public Subnet"
  default = "10.0.2.0/24"
}

variable "bastion_host_ami" {
  type = string
  default = "ami-05801d0a3c8e4c443"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone"
  default = "us-east-1a"
}

variable "volume_size" {
  type        = string
  description = "Size of the DB storage volume."
  default     = "10"
}

variable "environment_tag" {
  type        = string
  description = "Environment tag"
  default     = "Production"
}