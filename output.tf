# output "instance_ids" {
#   value = module.compute.instance_id #refrencing module instance_id output from compute module
# }

output "vpc_cidr" {
  value = var.vpc_cidr #vpc cidr from network module variable
}

# output "public_subnet_id" {
#   value = module.network.public_subnet_ids #refrencing public subnet id from network module output
# }

# output "private_subnet_ids" {
#   description = "Private subnet IDs"
#   value       = module.network.private_subnet_ids
# }

output "vpc_id" {
  value = module.network.vpc_id
}
output "db_endpoint" {
  value = module.db.dbendpoint
}

# output "application_urls" {
#   # This loops through the tuple and creates a list of strings
#   value = [for ip in module.compute.public_ip : "http://${ip}"]
# }
output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.compute.alb_dns_name
}