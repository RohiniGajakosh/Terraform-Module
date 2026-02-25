variable "source_mongodb_host" {
  type        = string
  description = "Current MongoDB host (IP or domain)"
  # e.g., "10.1.0.5" or "mongodb.company.com"
}

variable "source_mongodb_port" {
  type    = number
  default = 27017
}

variable "source_mongodb_user" {
  type      = string
  sensitive = true
}

variable "source_mongodb_pass" {
  type      = string
  sensitive = true
}

variable "source_mongodb_cidr" {
  type = string
  description = "CIDR block of source MongoDB (allow DMS to reach it)"
  # e.g., "203.0.113.5/32" for single IP, "10.0.0.0/8" for corporate network
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "environment" {
  type = string
  default = "dev"
}