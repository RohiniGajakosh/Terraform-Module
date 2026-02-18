output "bucketname" {
  value = aws_s3_bucket.logsbucket.bucket
}
output "bucketarn" {
  value = aws_s3_bucket.logsbucket.arn
}
output "alb_logs_policy_id" {
  value = aws_s3_bucket_policy.alb_logs_policy.id
}