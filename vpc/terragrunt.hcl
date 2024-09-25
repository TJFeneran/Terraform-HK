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

inputs = {
  default_vars = local.common_vars.default_vars
}