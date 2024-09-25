# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
provider "aws" {
  alias = "primary"
  region = "us-east-2"
  default_tags {
    tags = {
      Environment = "dev"
      Workload    = "HitchKick"
      Terraform   = "true"
    }
  }
}

provider "aws" {
  alias = "failover"
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "dev"
      Workload    = "HitchKick"
      Terraform   = "true"
    }
  }
}
