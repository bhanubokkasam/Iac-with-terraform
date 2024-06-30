provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2_autoscaling" {
  source = "./modules/ec2_autoscaling"
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

module "route53" {
  source = "./modules/route53"
  nat_gateway_id = module.vpc.nat_gateway_id
}
