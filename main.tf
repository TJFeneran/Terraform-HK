
// use config file & profiles for creds local, secrets in gh actions

//////////////////////////////////////////////////////////////
// REFER TO backend.tf FOR terraform init CONFIG (has hardcoded region)
//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////
// REFER TO variables.tf FOR VARIABLES
//////////////////////////////////////////////////////////////

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
//////////////////////////////////////////////////////////////
// RESOURCE CREATION
//////////////////////////////////////////////////////////////

module "primary_region_vpc" {
  source         = "./modules/region-vpc"
  region         = var.primary_region
  vpc_cidr_block = var.vpc_cidr_block_region_primary
  service_name   = var.service_name
  maxAZs         = var.maxAZs
  providers = {
    aws = aws.primary
  }
}


module "failover_region_vpc" {
  source         = "./modules/region-vpc"
  region         = var.failover_region
  vpc_cidr_block = var.vpc_cidr_block_region_failover
  service_name   = var.service_name
  maxAZs         = var.maxAZs
  providers = {
    aws = aws.failover
  }
}

