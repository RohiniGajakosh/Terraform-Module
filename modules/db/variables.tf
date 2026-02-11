variable "dbname" {
    description = "name of the database"
    type = string
    default = "mysqldb"
}

variable "dbusername" {
    description = "username for the database"
    type = string
}   
variable "dbpassword" {
  description = "Password for the database"
  type        = string
  sensitive   = true

  validation {
    condition = (
      length(var.dbpassword) >= 8
    )

    error_message = "DB password must be at least 8 characters and include uppercase, lowercase, number, and special character."
  }
}

variable "dballocatedstorage" {
    description = "allocated storage for the database"
    type = number
    default = 10
}
variable "dbinstanceclass" {
    description = "instance class for the database"
    type = string
    default = "db.t3.micro"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "environment" {
  type = string
  default = "dev"
}

variable "db_security_group_id" {
  type = string
  
}

variable "vpc_id" {
  type = string
}