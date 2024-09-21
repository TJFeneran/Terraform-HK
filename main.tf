
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
      Workload    = "${var.workload_name}"
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
      Workload    = "${var.workload_name}"
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
  vpc_cidr_block = var.vpc_cidr_block_region_primary
  workload_name  = var.workload_name
  maxAZs         = var.maxAZs
  providers = {
    aws = aws.primary
  }
}

/*
module "vpc_secondary" {
  source         = "./modules/region-vpc"
  vpc_cidr_block = var.vpc_cidr_block_region_failover
  workload_name  = var.workload_name
  maxAZs         = var.maxAZs
  providers = {
    aws = aws.failover
  }
}
*/