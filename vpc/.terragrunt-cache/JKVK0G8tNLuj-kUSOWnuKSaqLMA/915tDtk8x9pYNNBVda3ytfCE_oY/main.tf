/////////////////////////////////////////////////////////////
// VPC General Setup in Primary & Failover Regions
// VPC, Subnets, IGW / EIGW, Route Tables
/////////////////////////////////////////////////////////////

module "vpc" {
  source         = "./modules/vpc"
  default_vars = var.default_vars
}

/*
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
*/

//UPDATE SSM PARAMETER VALUES
resource "aws_ssm_parameter" "vpc-cidr-primary" {
  name  = "vpc-cidr-primary"
  type  = "String"
  value = module.vpc_primary.vpc_id
}
resource "aws_ssm_parameter" "vpc-cidr-failover" {
  name  = "vpc-cidr-failover"
  type  = "String"
  value = module.vpc_failover.vpc_id
}

/////////////////////////////////////////////////////////////
// VPC Endpoints in Primary & Failover Regions
// S3 Gateway, DynamoDB Gateway, SSM & SSM Messages
/////////////////////////////////////////////////////////////
/*
module "vpc_endpoints_primary" {
  source = "./modules/vpc-endpoints"
  vpc_id = module.vpc_primary.vpc_id

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = [module.vpc_primary.route_table_private.id, module.vpc_primary.route_table_public.id]
      tags            = { Name = "${var.workload_name} S3 Gateway VPC Endpoint" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc_primary.public_subnets[*].id
      tags                = { Name = "${var.workload_name} S3 SSM VPC Endpoint" }
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc_primary.public_subnets[*].id
      tags                = { Name = "${var.workload_name} SSM Messages VPC Endpoint" }
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = [module.vpc_primary.route_table_private.id, module.vpc_primary.route_table_public.id]
      tags            = { Name = "${var.workload_name} DynamoDB VPC Endpoint" }
    }
  }

  providers = {
    aws = aws.primary
  }
}

module "vpc_endpoints_failover" {
  source = "./modules/vpc-endpoints"
  vpc_id = module.vpc_failover.vpc_id

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = [module.vpc_failover.route_table_private.id, module.vpc_failover.route_table_public.id]
      tags            = { Name = "${var.workload_name} S3 Gateway VPC Endpoint" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc_failover.public_subnets[*].id
      tags                = { Name = "${var.workload_name} S3 SSM VPC Endpoint" }
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc_failover.public_subnets[*].id
      tags                = { Name = "${var.workload_name} SSM Messages VPC Endpoint" }
    }
  }

  providers = {
    aws = aws.failover
  }
}
*/