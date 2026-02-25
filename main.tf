module "network" {
  source   = "./modules/network"
  vpc_cidr = var.vpc_cidr
}
module "compute" {
  source          = "./modules/compute"
  environment     = var.environment
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnet_ids # This must match your VPC output name
  private_subnets = module.network.private_subnet_ids
  bucketname      = module.s3.bucketname
  # bucketarn = module.s3.bucketarn
  alb_logs_policy_dependency = module.s3.alb_logs_policy_id
}

module "s3" {
  source = "./modules/S3"
}
module "iam" {
  source = "./modules/IAM"
}

# module "db" {
#   source               = "./modules/db"
#   db_username           = var.DBUSERNAME
#   private_subnet_ids   = module.network.private_subnet_ids
#   db_security_group_id = module.compute.instance_sg_id
#   vpc_id               = module.network.vpc_id
# }

module "db" {
  source = "./modules/db"
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  availability_zones    = module.network.ava_zones
  db_username           = var.DBUSERNAME
  web_sg = module.compute.instance_sg_id

}

# module "dms" {
#   source = "./modules/dms"

#   environment         = var.environment
#   private_subnet_ids  = module.network.private_subnet_ids
#   source_mongodb_host = var.source_mongodb_port
#   source_mongodb_port = var.source_mongodb_port
#   source_mongodb_user = var.source_mongodb_user
#   source_mongodb_pass = var.source_mongodb_pass
#   source_mongodb_cidr = var.source_mongodb_cidr
# }