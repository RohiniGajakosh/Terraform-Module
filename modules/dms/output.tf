# ===== DMS OUTPUTS =====
output "dms_task_arn" {
  value = aws_dms_replication_task.mongodb_migration.replication_task_arn
}

output "dms_task_status" {
  value = aws_dms_replication_task.mongodb_migration.status
}