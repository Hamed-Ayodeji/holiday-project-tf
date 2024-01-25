module "vpc" {
  source = "../modules/vpc"
  cidr_block = var.cidr_block
  project_name = var.project_name
}

module "sg" {
  source = "../modules/sg"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "../modules/ec2"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  instance_type = var.instance_type
  bastion_id = module.sg.bastion_id
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_ids = module.vpc.private_subnet_ids
  private_sg_id = module.sg.private_sg_id
}

module "lb" {
  source = "../modules/lb"
  project_name = var.project_name
  lb_sg_id = module.sg.lb_sg_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_id = module.vpc.public_subnet_id
  vpc_id = module.vpc.vpc_id
  private_instance_ids = module.ec2.private_instance_ids
}

module "r53" {
  source = "../modules/r53"
  domain_name = var.domain_name
  subdomain_name = var.subdomain_name
  lb_dns_name = module.lb.lb_dns_name
  lb_zone_id = module.lb.lb_zone_id
  project_name = var.project_name
}