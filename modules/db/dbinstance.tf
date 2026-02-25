# resource "random_password" "docdb_password" {
#   length = 8
#   special = true
# }

# resource "aws_secretsmanager_secret" "dbsecret" {
#   name = "mysql-db-secret"
# }

# resource "aws_secretsmanager_secret_version" "dbsecret_value" {
#   secret_id = aws_secretsmanager_secret.dbsecret.id

#   secret_string = jsonencode({
#     username = var.db_username
#     password = random_password.dbpassword.result
#     engine   = "mysql"
#     db_name  = var.dbname
#     host = aws_db_instance.moduledb.id
#     port = 3306
#   })
# }
# resource "aws_db_instance" "moduledb" {
#   identifier = "mysqldb"
#   allocated_storage      = var.dballocatedstorage
#   max_allocated_storage  = 100 # Enables Storage Autoscaling
#   db_name                = var.dbname
#   engine                 = "mysql"
#   engine_version         = "8.0" # Ideally, use a more specific version like 8.0.35
#   instance_class         = var.dbinstanceclass
#   skip_final_snapshot    = true
#   # Credentials
#   username               = var.db_username
#   password               = random_password.dbpassword.result       # Consider using AWS Secrets Manager instead
  
#   # Network & Security
#   db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.db_sg.id]
#   publicly_accessible    = false
  
#   # Lifecycle & Maintenance
#   parameter_group_name   = "default.mysql8.0"
#   final_snapshot_identifier = "${var.dbname}-final-snapshot"
  
#   # Protect against accidental 'terraform destroy'
#   deletion_protection    = var.environment == "prod" ? true : false

#   lifecycle {
#     ignore_changes = [password] # Prevents password drift if changed manually
#   }
# }

# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "${var.environment}-db-subnet-group"
#   subnet_ids = var.private_subnet_ids
#   tags = {
#     Name        = "DBSubnetGroup"
#     Environment = var.environment
#   }
# }

# resource "aws_security_group" "db_sg" {
#   name        = "mysql-security-group"
#   description = "Security group for MySQL database"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     security_groups = [var.db_security_group_id] # Allows access from the compute instance which is called in rootmodule db and calling here from the main.tf of root module
#   }
#     tags = {
#         Name = "MySQLSecurityGroup"
#     }
# }

# ==============********************==================


# ===== RANDOM PASSWORD GENERATION =====
resource "random_password" "aurora_password" {
  length  = 16
  special = true
  # Avoid characters that have special meaning in connection strings (! % $ etc)
  override_special = "!&#$^<>-"
}

# ===== STORE PASSWORD IN SECRETS MANAGER =====

resource "aws_secretsmanager_secret" "aurora_secret" {
  name = "${var.environment}/aurora/admin-password"
}



resource "aws_secretsmanager_secret_version" "aurora_secret_value" {
  secret_id = aws_secretsmanager_secret.aurora_secret.id

  # Store connection string as JSON (app can parse it)
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.aurora_password.result
    port     = 5432
    dbname   = "postgres" # Default DB for Aurora PostgreSQL
    engine   = "aurora-postgresql"
  })
}

# ===== SECURITY GROUP FOR Aurora PostgreSQL =====
resource "aws_security_group" "aurora_sg" {
  name        = "${var.environment}-aurora-sg"
  description = "Security group for Aurora PostgreSQL"
  vpc_id      = var.vpc_id

  # Allow inbound from app security group only (port 5432 = PostgreSQL default)
  ingress {
    description     = "Allow from application servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.web_sg]  # Only from app
    # Alternative: cidr_blocks = [var.app_subnet_cidr]  # if using CIDR blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-aurora-sg"
  }
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.environment}-aurora-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "${var.environment}-aurora-subnet-group"
  }
}

#------Aurora PostgreSQL cluster -----------
resource "aws_rds_cluster" "aurora_postgres" {
  cluster_identifier      = "${var.environment}-aurora-cluster"
  engine                 = "aurora-postgresql"
  engine_version         = "15.3"
  master_username        = var.db_username
  master_password        = random_password.aurora_password.result
  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  backup_retention_period = 1
  preferred_backup_window = "03:00-04:00"
  preferred_maintenance_window = "sun:04:00-sun:05:00"
  skip_final_snapshot = var.environment == "dev" ? true : false
  storage_encrypted = var.environment=="prod" ? true : false
  deletion_protection = var.environment == "prod" ? true : false
  availability_zones = var.availability_zones
  engine_mode = "provisioned"
  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 1
  }

  enable_http_endpoint = true

  tags = {
    Name = "${var.environment}-aurora-postgres"
    Environment = var.environment
    ManagedBy = "terraform"
  }
}

# Aurora PostgreSQL cluster instance
resource "aws_rds_cluster_instance" "aurora_postgres_instance" {
  count               = var.environment == "prod" ? 2 : 1
  identifier          = "${var.environment}-aurora-instance-${count.index}"
  cluster_identifier  = aws_rds_cluster.aurora_postgres.id
  instance_class      = "db.serverless"
  engine              = "aurora-postgresql"
  engine_version      = "15.3"
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.aurora.name
  tags = {
    Name = "${var.environment}-aurora-instance-${count.index}"
  }
}



