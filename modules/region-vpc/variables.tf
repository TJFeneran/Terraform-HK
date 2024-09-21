variable "maxAZs" {
  description = "Maximum number of AZs to deploy subnets into"
  type        = number
  default     = 3
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "Service Name"
  type        = string
  default     = ""
}

variable "region" {
    description = "AWS Region"
    type = string
    default = ""

    validation {
        condition     = contains(["us-east-1", "us-east-2"], var.region)
        error_message = "Variable 'region' is missing or invalid in module."
    }
}