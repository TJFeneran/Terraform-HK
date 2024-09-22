/////////////////////////////////////////////////////////////
// VPC General Setup in Primary & Failover Regions
// VPC, Subnets, IGW / EIGW, Route Tables
/////////////////////////////////////////////////////////////
module "vpc_primary" {
  source         = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block_region_primary
  workload_name  = var.workload_name
  maxAZs         = var.maxAZs
  providers = {
    aws = aws.primary
  }
}

module "vpc_failover" {
  source         = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block_region_failover
  workload_name  = var.workload_name
  maxAZs         = var.maxAZs
  providers = {
    aws = aws.failover
  }
}