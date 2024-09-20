variable "environment" {
  description = "Environment"
  type        = string
  default     = "prod"

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

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16" //change to set this based on env
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDRs"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDRs"
  type        = list(string)
  default     = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
}