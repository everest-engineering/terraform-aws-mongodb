variable "name" {
  type        = string
  description = "Base name for the cluster and other resources"
}

variable "stage" {
  type        = string
  description = "Stage of the deployment (Production/Development etc)"
}

variable "tags" {
  type        = map(string)
  description = "Default tags to be attached for every resource in the module"
  default     = {}
}

variable "region" {
  type        = string
  description = "Region in which resources should be created"
}

variable "instance_type" {
  type        = string
  description = "Type of ECS container intance type"
}

variable "ebs_volume_type" {
  type        = string
  description = "Type of EBS volume to be used for container storage"
}

variable "ebs_volume_size" {
  type        = number
  description = "Size of ebs volume"
}

variable "mongo_container_cpu" {
  type        = number
  description = "CPU capacity required for mongo container ( 1024 == 1 cpu)"
}

variable "mongo_version" {
  type        = string
  description = "Docker image version of mongo"
}

variable "mongo_container_memory" {
  type        = number
  description = "Memory required for mongo container"
}

variable "security_group_id" {
  type        = string
  description = "Security group id for container EC2 instance"
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for container EC2 instance"
}