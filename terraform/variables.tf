variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
  default     = "us-east-1"
}

variable "app_ports" {
  description = "Application ports to open"
  type        = list(number)
  default     = [8081, 8082, 8083]
}