variable "workload_name" {
  description = "Workload Name"
  type        = string
  default     = ""
}

variable "aurora_global_primary_hosts" {
  description = "Default number of instances in regional cluster"
  type        = number
  default     = 0
}

variable "aurora_global_failover_hosts" {
  description = "Default number of instances in regional cluster"
  type        = number
  default     = 0
}