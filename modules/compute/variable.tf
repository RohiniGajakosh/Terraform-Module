variable "instance_type" {
  description = "the type of instance"
  type = string
  default = "t3.micro"
}

variable "instance_count" {
  description = "the number of instance count"
  type = number 
  default = 3
}

variable "environment" {
  description = "the environment "
  type = string
  default = "dev"
}

variable "subnet_id" {
  description = "the subnet id"
  type = string
}


variable "vpc_id" {
  description = "the vpc id"
  type = string
}
variable "public_subnets" { 
  description = "the public subnets"
  type = list(string) 
}

# Note: You can also use a map of objects for more complex security group rules.
# This allows you to define multiple rules in a more structured way.
variable "web_ingress_rules" {
  type = map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string) # Consider using a more specific CIDR block for better security!
  }))
  default = {
    "ssh" = {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # Consider narrowing this to your IP for better security!
    },

  }
}