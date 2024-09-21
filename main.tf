
////////////////////////////////////////////////////////////////////////
// REFER TO backend.tf FOR terraform init CONFIG (has hardcoded region)
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// REFER TO variables.tf FOR VARIABLES DICTIONARY (./modules too)
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// REFER TO <env>.tfvars FOR RUNTIME ENV VARIABLES
////////////////////////////////////////////////////////////////////////


//configure provider
provider "aws" {

  alias   = "primary"
  profile = var.awscredsprofile
  region  = var.primary_region

  default_tags {
    tags = {
      Environment = "${var.environment}"
      Workload    = "${var.service_name}"
      Terraform   = "true"
    }
  }
}

provider "aws" {

  alias   = "failover"
  profile = var.awscredsprofile
  region  = var.failover_region

  default_tags {
    tags = {
      Environment = "${var.environment}"
      Workload    = "${var.service_name}"
      Terraform   = "true"
    }
  }
}

////////////////////////////////////////////////////////////////////////
// RESOURCE CREATION
////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////
// VPC General Setup in Both Regions
// VPC, Subnets, IGW / EIGW, Route Tables
/////////////////////////////////////////////////////////////
module "vpc_primary" {
  source         = "./modules/region-vpc"
  region         = var.primary_region
  vpc_cidr_block = var.vpc_cidr_block_region_primary
  workload_name   = var.workload_name
  maxAZs         = var.maxAZs
  providers = {
    aws = aws.primary
  }
}


module "vpc_secondary" {
  source         = "./modules/region-vpc"
  region         = var.failover_region
  vpc_cidr_block = var.vpc_cidr_block_region_failover
  workload_name   = var.workload_name
  maxAZs         = var.maxAZs
  providers = {
    aws = aws.failover
  }
}

/////////////////////////////////////////////////////////////
// VPC Endpoints in Both Regions
/////////////////////////////////////////////////////////////


module "vpc_enpdoints_primary" {
  vpc_id       = module.vpc_primary.vpc_id
  source       = "./modules/region-vpc-endpoints"
  region       = var.primary_region
  workload_name = var.workload_name
  providers = {
    aws = aws.primary
  }
}

/*
module "vpc_enpdoints_failover" {
  
  source         = "./modules/region-vpc-endpoints"
  region         = var.failover_region
  workload_name   = var.service_name
  providers = {
    aws = aws.failover
  }
}
*/