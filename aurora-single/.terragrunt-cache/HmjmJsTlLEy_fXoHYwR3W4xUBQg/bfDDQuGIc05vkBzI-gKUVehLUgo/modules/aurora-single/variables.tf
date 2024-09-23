variable "workload_name" {
  description = "Workload Name"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region to use"
  type        = string
  default = ""

    validation {
      condition     = length(var.region) > 0
      error_message = "Variable 'region' is missing or invalid. Remember to use a var-file."
    }
}

variable "instances" {
    description = "Number of instances to deploy"
    type = number
    default = 0
}

variable "cluster_name" {
    description = "Name of cluster"
    type = string
    default = "cluster"
}
