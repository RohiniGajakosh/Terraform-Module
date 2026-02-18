# output "instance_id" {
#   value = aws_instance.myinstance[*].id  
# }

# output "public_ip" {
#   value = aws_instance.myinstance[*].public_ip
# }
# output "private_ip" {
#   value = aws_instance.myinstance[*].private_ip
# }
output "instance_sg_id" {
  value = aws_security_group.web_sg.id
}
output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.applb.dns_name
}