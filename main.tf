module "network" {
  source   = "./modules/network"
  vpc_cidr = var.vpc_cidr
}
module "compute" {
  source         = "./modules/compute"
  environment    = var.environment
  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnet_ids    # This must match your VPC output name
  private_subnets = module.network.private_subnet_ids
  bucketname = module.s3.bucketname
  # bucketarn = module.s3.bucketarn
  alb_logs_policy_dependency = module.s3.alb_logs_policy_id 
}

module "s3" {
  source = "./modules/S3"
}
module "iam" {
  source = "./modules/IAM"
}

module "db" {
  source               = "./modules/db"
  db_username           = var.DBUSERNAME
  private_subnet_ids   = module.network.private_subnet_ids
  db_security_group_id = module.compute.instance_sg_id
  vpc_id               = module.network.vpc_id
}

