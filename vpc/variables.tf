variable "workload_name" {
  description = "Workload Name"
  type        = string
  default     = ""
}

variable "region_primary" {
  description = "AWS Primary Region"
  type        = string
  default     = ""

  validation {
    condition     = length(var.region_primary) > 0
    error_message = "Variable 'region_primary' is missing or invalid."
  }
}

variable "region_failover" {
  description = "AWS Failover Region"
  type        = string
  default     = ""

  validation {
    condition     = length(var.region_failover) > 0
    error_message = "Variable 'region_failover' is missing or invalid."
  }
}

variable "maxAZs" {
  description = "Maximum number of AZs to deploy subnets into"
  type        = number
  default     = 3
}

variable "vpc_cidr_block_region_primary" {
  description = "CIDR block for Primary VPC"
  type        = string
  default     = ""

  validation {
    condition     = length(var.vpc_cidr_block_region_primary) > 0
    error_message = "Variable 'vpc_cidr_block_region_primary' is missing or invalid."
  }
}

variable "vpc_cidr_block_region_failover" {
  description = "CIDR block for FailoverVPC"
  type        = string
  default     = ""

  validation {
    condition     = length(var.vpc_cidr_block_region_failover) > 0
    error_message = "Variable 'vpc_cidr_block_region_failover' is missing or invalid."
  }
}
