# output "dbport" {
#   value = aws_db_instance.moduledb.port
# }
# output "dbendpoint" {
#   value = aws_db_instance.moduledb.endpoint
# }
# output "dbid" {
#   value = aws_db_instance.moduledb.id
# }
# output "dbname" {
#   value = aws_db_instance.moduledb.db_name
# }
# output "dbarn" {
#   value = aws_db_instance.moduledb.arn
# }
# output "vpc_id" {
#   value = var.vpc_id
# }

output "aurora_endpoint" {
  value = aws_rds_cluster.aurora_postgres.endpoint
  description = "Aurora PostgreSQL cluster endpoint (for app connection string)"
}

output "aurora_port" {
  value = 5432
}

output "aurora_secret_arn" {
  value = aws_secretsmanager_secret.aurora_secret.arn
  description = "ARN of secret containing Aurora DB credentials"
}