variable "environment" {
  description = "Environment"
  type        = string
  default     = "stage"

  validation {
    condition     = contains(["stage", "prod"], var.environment)
    error_message = "variable 'environment' is missing or invalid."
  }
}

variable "service_name" {
  description = "Workload Name"
  type        = string
  default     = "HitchKick"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"

  validation {
    condition = containers(["us-east-1","us-east-2"], var.region)
    error_message = "variable 'region' is missing or invalid"
  }
}

variable "maxAZs" {
  description = "Maximum number of AZs to deploy subnets into"
  type        = number
  default     = 3
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}