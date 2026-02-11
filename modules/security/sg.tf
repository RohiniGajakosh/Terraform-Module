resource "aws_security_group" "albsg" {
  name        = "my-security-group"
  description = "Security group for HTTP access"
  vpc_id      = var.myvpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
        Name = "LoadBalancer_SecurityGroup"
    }
}



resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP inbound"
  vpc_id      = var.myvpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
        Name = "WebServer_SecurityGroup"
    }
}

resource "aws_security_group" "db_sg" {
  name        = "database-sg"
  description = "Allow MySQL from Web SG"
  vpc_id      = var.myvpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id] # The "Glue": allow the web_sg
  }
  tags = {
        Name = "Database_SecurityGroup"
    }
}


