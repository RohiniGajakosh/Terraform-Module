output "vpc_id" {
  value = aws_vpc.myvpc.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = aws_subnet.publicsubnet[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.privatesubnet[*].id
}

