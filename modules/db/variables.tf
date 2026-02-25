# variable "dbname" {
#     description = "name of the database"
#     type = string
#     default = "mysqldb"
# }
# variable "dballocatedstorage" {
#     description = "allocated storage for the database"
#     type = number
#     default = 10
# }
# variable "dbinstanceclass" {
#     description = "instance class for the database"
#     type = string
#     default = "db.t3.micro"
# }

variable "private_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}


variable "db_username" {
  description = "username for the database"
  type = string
  default = "aurora_admin"
} 
# variable "documentdb_sg" {
#   type = string
# }

variable "web_sg" {
  type        = string
  description = "Security group ID of the app (ECS/EC2)"
}
variable "environment" {
  type = string
  default = "dev"
}

variable "availability_zones" {
  type = list(string)
}