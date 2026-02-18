locals {
  commontags = {
    Managedby   = "terraform"
    Project     = "WebApp using Modules"
    # Note: timestamp() updates on every apply. 
    # Consider using a static variable if you only want the 'original' creation date.
    CreateDate = formatdate("YYYY-MM-DD hh:mm:ss Z", timestamp())
    Environment = var.environment
  }  
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_security_group" "web_sg" {
  name        = "web-Security-Group"
  description = "Allow web access"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.web_ingress_rules
    content {
      description      = "Rule for ${ingress.key}"
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
    }
  }
   # HTTP only from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.commontags,
    {
      Name = "web-Security-Group"
    }
  )
   lifecycle {
     ignore_changes = [tags["CreateDate"]] # Prevents tag changes from triggering securitygroup replacement
  }
}


# resource "aws_instance" "myinstance" {
#   count         = var.instance_count
#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = var.instance_type
#   subnet_id     = var.public_subnets[count.index % length(var.public_subnets)] # Distributes instances across available public subnets
#   key_name      = "awskey"
#   vpc_security_group_ids = [aws_security_group.web_sg.id]
#  #userdata runs on first boot of the instance and is used to install docker and run the containerized app. 
#  #so if made anychanges here please destroy the instances and apply again to see the changes in effect.
#   user_data = <<-EOF
#     #!/bin/bash
#     sudo yum update -y
#     sudo amazon-linux-extras install docker -y
#     sudo systemctl enable docker
#     sudo systemctl start docker
#     sudo usermod -a -G docker ec2-user
#     sudo docker pull rohinigajakosh/my-terraform-app:v2
#     sudo docker run -d -p 80:80 rohinigajakosh/my-terraform-app:v2
#   EOF
#   tags = merge(
#     local.commontags,
#     {
#       Name = "MyInstance-${count.index + 1}" # +1 makes naming 1-based instead of 0-based
#     }
#   )
#   lifecycle {
#     ignore_changes = [tags["CreateDate"]] # Prevents tag changes from triggering instance replacement
#   }
# }


resource "aws_instance" "bastionhost" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnets[0]
  key_name      = "awskey"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "Bastion-EC2-Instance"
  }

}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-Security-Group"
  description = "Allow web access"
  vpc_id      = var.vpc_id
  ingress {
    description = "ssh into bastion host"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}