
include "root" {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
}

# Indicate the input values to use for the variables of the module.
inputs = {
  workload_name     = "${local.common_vars.workload_name}"
  tags = {
  }
}