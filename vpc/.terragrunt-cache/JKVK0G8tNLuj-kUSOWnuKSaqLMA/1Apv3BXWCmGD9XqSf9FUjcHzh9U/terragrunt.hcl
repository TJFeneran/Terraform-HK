################################################################################
# VPC MAIN HCL
################################################################################

include "root" {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  source = "main.tf"
}

# Indicate the input values to use for the variables of the module.
inputs = {
  default_vars = local.common_vars.default_vars
}