
locals {
  common_vars             = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  workload_name           = local.common_vars.workload_name
  region_primary          = local.common_vars.region_primary
  region_failover         = local.common_vars.region_failover
  vpc_cidr_block_primary  = local.common_vars.vpc_cidr_block_primary
  vpc_cidr_block_failover = local.common_vars.vpc_cidr_block_failover
  maxAZs                  = local.common_vars.maxAZs
}

terraform {
  source = "./main.tf"
}

# Indicate the input values to use for the variables of the module.
inputs = {
  workload_name     = "${local.workload_name}"
  vpc_cidr_primary  = "${local.vpc_cidr_block_primary}"
  vpc_cidr_failover = "${local.vpc_cidr_block_failover}"
  maxAZs            = local.maxAZs

  tags = {
  }
}