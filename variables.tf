variable "environment" {
  description = "Environment"
  type        = string
  default     = ""

  validation {
    condition     = contains(["stage", "prod"], var.environment)
    error_message = "Variable 'environment' is missing or invalid. Right workspace / var-file?"
  }
}

variable "workload_name" {
  description = "Workload Name"
  type        = string
  default     = ""

  validation {
    condition     = length(var.workload_name) > 0
    error_message = "Variable 'workload_name' is missing or invalid. Right workspace / var-file?"
  }
}

variable "awscredsprofile" {
  description = "AWS Creds Profile Name"
  type        = string
  default     = ""

  validation {
    condition     = length(var.awscredsprofile) > 0
    error_message = "Variable 'awscredsprofile' is missing or invalid. Right workspace / var-file?"
  }
}

variable "primary_region" {
  description = "AWS Primary Region"
  type        = string
  default     = ""

  validation {
    condition     = contains(["us-east-1", "us-east-2"], var.primary_region)
    error_message = "Variable 'primary_region' is missing or invalid. Right workspace / var-file?"
  }
}

variable "failover_region" {
  description = "AWS Failover Region"
  type        = string
  default     = ""

  validation {
    condition     = contains(["us-east-1", "us-east-2"], var.failover_region)
    error_message = "Variable 'failover_region' is missing or invalid. Right workspace / var-file?"
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
}

variable "vpc_cidr_block_region_failover" {
  description = "CIDR block for FailoverVPC"
  type        = string
  default     = ""
}