variable "default_vars" {
  description = "Contains all default variables from root common_vars.yaml"
  type        = any
}

variable "region" {
  description = "AWS region to use"
  type        = string
  default     = ""

  validation {
    condition     = length(var.region) > 0
    error_message = "Variable 'region' is missing or invalid. Remember to use a .tfvar file with 'region' variable"
  }
}

variable "instances" {
  description = "Number of instances to deploy"
  type        = number
  default     = 0
}

variable "cluster_name" {
  description = "Name of cluster"
  type        = string
  default     = "cluster"
}

variable "storage_type" {
  description = "instance storage type"
  type        = string
  default     = ""
}

variable "db_cluster_instance_class" {
  description = "Family & size of instance(s) deployed to cluster"
  type        = string
  default     = ""
}

variable "iops" {
  description = "Storage IOPS per instance"
  type        = number
  default     = 0
}

variable "allocated_storage" {
  description = "Size (in Gb) for cluster instances"
  type        = number
  default     = 0
}