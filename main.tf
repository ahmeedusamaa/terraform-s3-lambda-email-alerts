module "compute" {
  source = "./modules/compute"
  Application_ec2 = var.Application_ec2 
  ami_id        = var.ami_id
  public_subnets = module.network.public_subnet
  private_subnets = module.network.private_subnet
  app_security_groups = [module.network.app_sg_id]
  Bastion_security_groups = [module.network.allow_ssh_sg_id]
}

module "network" {
  source = "./modules/network"
  vpc_cidr_block = var.vpc_cidr_block
  subnets = var.subnets
  region = var.region
}

module "storage" {
  source = "./modules/storage"
  redis_security_group = module.network.redis_sg_id
  public_subnets = module.network.public_subnet
  private_subnets = module.network.private_subnet
  rds_instance = var.rds_instance
  rds_security_group = module.network.rds_sg_id
  redis_subnet_group = module.network.redis_sg_id
}

