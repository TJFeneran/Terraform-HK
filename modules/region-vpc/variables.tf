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

variable "workload_name" {
  description = "Workload Name"
  type        = string
  default     = ""
}