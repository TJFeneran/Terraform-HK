/////////////////////////////////////////////////////////////
// VPC General Setup in Primary & Failover Regions
// VPC, Subnets, IGW / EIGW, Route Tables
/////////////////////////////////////////////////////////////

module "vpc_primary" {
  source       = "./modules/vpc"
  region_alias = "primary"
  default_vars = var.default_vars

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = [module.vpc_primary.route_table_private.id, module.vpc_primary.route_table_public.id]
      tags            = { Name = "${var.default_vars.workload_name} S3 Gateway VPCe" }
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = [module.vpc_primary.route_table_private.id, module.vpc_primary.route_table_public.id]
      tags            = { Name = "${var.default_vars.workload_name} DynamoDB Gateway VPCe" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc_primary.public_subnets[*].id
      tags                = { Name = "${var.default_vars.workload_name} S3 SSM Interface VPCe" }
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc_primary.public_subnets[*].id
      tags                = { Name = "${var.default_vars.workload_name} SSM Messages Interface VPCe" }
    }
  }

  providers = {
    aws = aws.primary
  }
}

module "vpc_failover" {
  source       = "./modules/vpc"
  region_alias = "failover"
  default_vars = var.default_vars

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = [module.vpc_failover.route_table_private.id, module.vpc_failover.route_table_public.id]
      tags            = { Name = "${var.default_vars.workload_name} S3 Gateway VPCe" }
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = [module.vpc_failover.route_table_private.id, module.vpc_failover.route_table_public.id]
      tags            = { Name = "${var.default_vars.workload_name} DynamoDB Gateway VPCe" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc_failover.public_subnets[*].id
      tags                = { Name = "${var.default_vars.workload_name} S3 SSM Interface VPCe" }
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc_failover.public_subnets[*].id
      tags                = { Name = "${var.default_vars.workload_name} SSM Messages Interface VPCe" }
    }
  }

  providers = {
    aws = aws.failover
  }
}