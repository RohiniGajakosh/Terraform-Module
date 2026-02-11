data "aws_secretsmanager_secret" "dbpassword" {
  name = "${var.environment}/mysql/dbpassword"
}

data "aws_secretsmanager_secret_version" "dbpasswordversion" {
  secret_id = data.aws_secretsmanager_secret.dbpassword.id
}
resource "aws_db_instance" "moduledb" {
  allocated_storage      = var.dballocatedstorage
  max_allocated_storage  = 100 # Enables Storage Autoscaling
  db_name                = var.dbname
  engine                 = "mysql"
  engine_version         = "8.0" # Ideally, use a more specific version like 8.0.35
  instance_class         = var.dbinstanceclass
  skip_final_snapshot    = true
  # Credentials
  username               = var.dbusername
  password               = data.aws_secretsmanager_secret_version.dbpasswordversion.secret_string # Consider using AWS Secrets Manager instead
  
  # Network & Security
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  
  # Lifecycle & Maintenance
  parameter_group_name   = "default.mysql8.0"
  final_snapshot_identifier = "${var.dbname}-final-snapshot"
  
  # Protect against accidental 'terraform destroy'
  deletion_protection    = var.environment == "prod" ? true : false

  lifecycle {
    ignore_changes = [password] # Prevents password drift if changed manually
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name        = "DBSubnetGroup"
    Environment = var.environment
  }
}

resource "aws_security_group" "db_sg" {
  name        = "mysql-security-group"
  description = "Security group for MySQL database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.db_security_group_id] # Allows access from the compute instance which is called in rootmodule db and calling here from the main.tf of root module
  }
    tags = {
        Name = "MySQLSecurityGroup"
    }
}
