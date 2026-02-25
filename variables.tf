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

variable "DBUSERNAME" {
  description = "username for the database"
  type        = string
}
variable "AWS_ACCESS_KEY_ID" {
  description = "aws access key id to loginto the aws"
  type        = string
}

variable "AWS_REGION" {
  description = "AWS Region to create the resources"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "Aws secret key to loginto aws"
  type        = string
}

# variable "availability_zones" {
#   type = list(string)
# }
variable "source_mongodb_port" {
  type    = number
  default = 27017
}

variable "source_mongodb_user" {
  type      = string
  sensitive = true
  default   = "root" # Example, replace as needed
}

variable "source_mongodb_pass" {
  type      = string
  sensitive = true
}

variable "source_mongodb_cidr" {
  type        = string
  description = "CIDR block of source MongoDB (allow DMS to reach it)"
  default     = "0.0.0.0/0" 
}
