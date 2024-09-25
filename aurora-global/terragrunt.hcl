################################################################################
# Global Aurora Cluster
################################################################################

include "root" {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
}

inputs = {
  default_vars = local.common_vars.default_vars
}