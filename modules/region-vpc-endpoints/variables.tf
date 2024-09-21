variable "workload_name" {
  description = "Workload Name"
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

variable vpc_id {
    description = "VPC to assign endpoint to"
      type        = string
     default     = ""
}