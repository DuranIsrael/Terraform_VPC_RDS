terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_vpc" "TF_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "TF vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.TF_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.TF_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public subnet 2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.TF_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private subnet 1"
  }
}

resource "aws_internet_gateway" "TF_ig" {
  vpc_id = aws_vpc.TF_vpc.id
  
  tags = {
    Name = "TF internet gateway"
  }
}

resource "aws_lb" "TF_lb" {
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "TF_lb"
  }
}

resource "aws_db_instance" "TF_db" {
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t2.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0.28"
  skip_final_snapshot  = true
}