module "network" {
  source   = "./modules/network"
  vpc_cidr = var.vpc_cidr
}
module "compute" {
  source         = "./modules/compute"
  environment    = var.environment
  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnet_ids    # This must match your VPC output name
  subnet_id      = module.network.public_subnet_ids[0] # Example: using the first public subnet for instances
}

module "s3" {
  source = "./modules/S3"
}
module "iam" {
  source = "./modules/IAM"
}

module "db" {
  source               = "./modules/db"
  dbpassword           = var.dbpassword
  private_subnet_ids   = module.network.private_subnet_ids
  db_security_group_id = module.compute.instance_sg_id
  vpc_id               = module.network.vpc_id
}

