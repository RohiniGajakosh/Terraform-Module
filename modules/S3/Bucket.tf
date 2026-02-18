resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "logsbucket" {
  bucket = "logs-bucket-${random_id.bucket_id.hex}"
  tags = {
    Name = "MyLogsBucket"
  }
}
resource "aws_s3_bucket_policy" "alb_logs_policy" {
  bucket = aws_s3_bucket.logsbucket.id

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "logdelivery.elasticloadbalancing.amazonaws.com"
      },
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": "arn:aws:s3:::logs-bucket-3e095dc9/AWSLogs/*"
    },
    {
      "Sid": "AWSLogDeliveryAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "logdelivery.elasticloadbalancing.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::logs-bucket-3e095dc9"
    }
  ]
})
}
