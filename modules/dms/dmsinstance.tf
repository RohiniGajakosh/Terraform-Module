resource "aws_dms_replication_instance" "mongodb_to_docdb" {
 replication_instance_id = "${var.environment}-mongo-to-docdb" 
 replication_instance_class = var.environment == "prod" ? "dms.c5.large" : "dms.t3.micro"
 allocated_storage = 100
 replication_subnet_group_id = aws_dms_replication_subnet_group.dms.id
 vpc_security_group_ids = [aws_security_group.dms_sg.id]
 multi_az = var.environment == "prod" ? true : false
 publicly_accessible = false  # NEVER expose DMS to internet
 engine_version = "3.4.6" 
  tags = {
    Name = "${var.environment}-dms-instance"
  }
}

# ===== DMS SUBNET GROUP =====
resource "aws_dms_replication_subnet_group" "dms" {
  replication_subnet_group_id          = "${var.environment}-dms-subnet-group"
  replication_subnet_group_description = "DMS subnet group for MongoDB migration"
  subnet_ids = var.private_subnet_ids
  
  tags = {
    Name = "${var.environment}-dms-subnet-group"
  }
}

# ===== SOURCE ENDPOINT (Current MongoDB) =====
resource "aws_dms_endpoint" "source_mongodb" {
  endpoint_id = "source_mongodb-endpoint"
  endpoint_type = "source"
  engine_name   = "mongodb"
  
  # Connection details to your CURRENT MongoDB
  # If MongoDB is local/Docker: use public IP or NAT instance
  # If MongoDB is on EC2: use private IP (DMS must be in same VPC)
  # Best practice: Source should also be in AWS for security
  server_name = var.source_mongodb_host  # e.g., "10.1.0.5" or "my-mongo.example.com"
  port        = var.source_mongodb_port  # Default: 27017
  username    = var.source_mongodb_user  # e.g., "admin"
  password    = var.source_mongodb_pass  # Store in Secrets Manager in real setup
  
  # Optional: Connection test before migration
  database_name = "userdb"  # Database to migrate
  
  # Certificate for SSL/TLS (if source MongoDB enforces SSL)
  # ssl_mode = "require"
  # certificate_arn = aws_acm_certificate.mongo.arn
  
  tags = {
    Name = "source-mongodb"
  }
}