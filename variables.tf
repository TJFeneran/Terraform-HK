variable "environment" {
  description = "Environment"
  type        = string
  default     = ""

  validation {
    condition     = contains(["stage", "prod"], var.environment)
    error_message = "variable 'environment' is missing or invalid. Remember to 'terraform workspace select <env>' first."
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
  default     = ""

  validation {
    condition     = contains(["us-east-1", "us-east-2"], var.region)
    error_message = "variable 'region' is missing or invalid. Remember to 'terraform workspace select <env>' first."
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