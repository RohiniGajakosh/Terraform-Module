resource "aws_secretsmanager_secret" "dbpassword" {
  name        = "${var.env}/mysql/dbpassword"
  description = "Database password"
  tags = {
    Environment = var.env
    Name        = "${var.env}-db-password"
  }
  
}
resource "aws_secretsmanager_secret_version" "dbpasswordversion" {
  secret_id     = aws_secretsmanager_secret.dbpassword.id
  secret_string = var.dbpassword
  
}