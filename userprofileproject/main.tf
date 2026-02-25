terraform {
  required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "6.33.0"
  }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "public_instace" {
  ami = ""
  instance_type = "t3.micro"
  key_name = "aws_key"
  subnet_id = "subnet-0c25d0b647b6ea4a8"
  associate_public_ip_address = true
  tags = {
    Name = "server-instance"

  }
}

resource "aws_security_group" "pb-sg" {
  name_prefix = "public-sg"
  vpc_id = "vpc-07bd3e1e77d5fa2b8"
  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
  ingress  {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
  ingress  {
    from_port = 8081
    to_port = 8081
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
}

