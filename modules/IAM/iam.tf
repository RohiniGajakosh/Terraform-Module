resource "aws_iam_user" "myiamuser" {
  name = "module-user"
}

resource "aws_iam_user_login_profile" "myiamuser" {
  user                    = aws_iam_user.myiamuser.name
  password_reset_required = false
}

# Combined Policy: Minimizes resource overhead and API calls
resource "aws_iam_user_policy" "combined_access" {
  name = "module-user-permissions"
  user = aws_iam_user.myiamuser.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"]
        Resource = "*" # Best practice: Narrow this to specific buckets in production
      },
      {
        Effect   = "Allow"
        Action   = [
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeVolumes"
        ]
        Resource = "*"
      }
    ]
  })
}


# resource "aws_iam_user" "myiamuser" {
#   name = "module-user"
# }

# resource "aws_iam_user_login_profile" "myiamuser" {
#   user = aws_iam_user.myiamuser.name
#   password_reset_required = false
# #   pgp_key = "keybase:someuser"
# }

# # resource "aws_iam_user_policy_attachment" "attach" {
# #   user       = aws_iam_user.myiamuser.name
# #   for_each = {
# #     s3access = aws_iam_user_policy.s3access.arn,
# #     ec2access = aws_iam_user_policy.ec2access.arn
# #   }
# #   policy_arn = each.value
# # }

# resource "aws_iam_user_policy" "s3access" {
#   name = "s3-access-policy"
#   user = aws_iam_user.myiamuser.name

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "s3:ListBucket",
#           "s3:GetObject",
#           "s3:PutObject"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
  
# }

# resource "aws_iam_user_policy" "ec2access" {
#   name = "ec2-access-policy"
#   user = aws_iam_user.myiamuser.name

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:DescribeInstances",
#           "ec2:DescribeSecurityGroups",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeVpcs",
#           "ec2:DescribeKeyPairs",
#           "ec2:DescribeVolumes"
        
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
  
# }
