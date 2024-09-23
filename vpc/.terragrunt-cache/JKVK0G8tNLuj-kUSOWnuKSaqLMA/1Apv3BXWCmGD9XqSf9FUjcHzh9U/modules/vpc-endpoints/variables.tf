variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used"
  type        = string
  default     = null
}

variable "endpoints" {
  description = "A map of interface and/or gateway endpoints containing their properties and configurations"
  type        = any
  default     = {}
}

variable "subnet_ids" {
  description = "Default subnets IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []
}

variable "route_table_ids" {
  description = "Route table IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting VPC endpoint resources"
  type        = map(string)
  default     = {}
}

variable "default_vars" {
  description = "Contains all default variables from root common_vars.yaml"
  type = any
}

variable "region_alias" {
  type = string
  default = ""
}