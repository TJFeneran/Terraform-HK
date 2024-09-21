variable "environment" {
  description = "Environment"
  type        = string
  default     = "stage"

  validation {
    condition     = contains(["stage", "prod"], var.environment)
    error_message = "variable 'environment' is missing or invalid."
  }
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "service_name" {
  description = "Workload Name"
  type        = string
  default     = "HitchKick"
}

variable "maxAZs" {
  description = "Maximum number of AZs to deploy subnets into"
  type        = number
  default     = 3
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16" //change to set this based on env
}

variable "public_subnet_cidrs" {
  description = "Public Subnet IPv4 CIDRs"
  type        = list(string)
  default     = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
}

variable "private_subnet_cidrs" {
  description = "Private Subnet IPv4 CIDRs"
  type        = list(string)
  default     = ["10.0.12.0/22", "10.0.16.0/22", "10.0.20.0/22"]
}