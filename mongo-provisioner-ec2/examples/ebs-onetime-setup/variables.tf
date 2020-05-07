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
