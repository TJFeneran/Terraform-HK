locals {
  common_vars = yamldecode(file("common_vars.yaml"))
}

terraform {

}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  alias = "primary"
  region = "${local.common_vars.region_primary}"
  default_tags {
    tags = {
      Environment = "${local.common_vars.environment}"
      Workload    = "${local.common_vars.workload_name}"
      Terraform   = "true"
    }
  }
}

provider "aws" {
  alias = "failover"
  region = "${local.common_vars.region_failover}"
  default_tags {
    tags = {
      Environment = "${local.common_vars.environment}"
      Workload    = "${local.common_vars.workload_name}"
      Terraform   = "true"
    }
  }
}
EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "hitchkick-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "aws-tf-state"
  }
}
EOF
}