################################################################################
# Single-Region Aurora Cluster
################################################################################

include "root" {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  source = "./modules/aurora-single"
}

# Indicate the input values to use for the variables of the module.
inputs = {
  workload_name = "${local.common_vars.default_vars.workload_name}"

  tags = {
  }
}
