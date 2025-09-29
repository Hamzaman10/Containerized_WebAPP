terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.6"
}

provider "aws" {
  region  = var.aws_region
  profile = "default"
}

# Import global default tags
module "default_tags" {
  source = "./global_vars"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get subnets of default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  subnet_id = data.aws_subnets.default.ids[0]
}

# Security group
resource "aws_security_group" "ec2_sg" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.app_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "assignment1-sg"
  }, module.default_tags.default_tags)
}

# ECR repositories
resource "aws_ecr_repository" "webapp" {
  name = "webapp"
  tags = module.default_tags.default_tags
}

resource "aws_ecr_repository" "mysqldb" {
  name = "mysqldb"
  tags = module.default_tags.default_tags
}

# AMI for Amazon Linux 2
data "aws_ami" "amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 instance
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = "vockey"

  tags = merge({
    Name = "assignment1-ec2"
  }, module.default_tags.default_tags)
}
