# variable "instance_type" {
#   description = "the type of instance"
#   type = string
#   default = "t3.micro"
# }

# variable "instance_count" {
#   description = "the number of instance count"
#   type = number 
#   default = 3
# }

variable "environment" {
  description = "the environment "
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "cidrblock for the vpc"
  type        = string
  default     = "10.1.0.0/16"
}


variable "dbpassword" {
  description = "password for the database"
  type        = string
  sensitive   = true
}

