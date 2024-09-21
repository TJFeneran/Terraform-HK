/////////////////////////////////////////////////////////////
// VPC Endpoints in Both Regions
/////////////////////////////////////////////////////////////


module "vpc_endpoints_primary" {
  source = "./modules/region-vpc-endpoints"
  vpc_id = module.vpc_primary.vpc_id
  region = var.primary_region
  create = false

  endpoints = {
    s3 = {
      service      = "s3"
      service_type = "Gateway"
      tags         = { Name = "${var.workload_name} S3 Gateway VPC Endpoint" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc_primary.private_subnets[*].id
      tags                = { Name = "${var.workload_name} S3 SSM VPC Endpoint" }
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc_primary.private_subnets[*].id
      tags                = { Name = "${var.workload_name} SSM Messages VPC Endpoint" }
    }
  }
  tags = {

  }

  providers = {
    aws = aws.primary
  }
}

/*
module "vpc_enpdoints_failover" {
  vpc_id        = module.vpc_secondary.vpc_id
  source        = "./modules/region-vpc-endpoints"
  region        = var.failover_region
  workload_name = var.workload_name
  create        = true

  providers = {
    aws = aws.failover
  }
}
*/