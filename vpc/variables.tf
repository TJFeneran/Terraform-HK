variable "default_vars" {
  description = "Contains all default variables from root common_vars.yaml"
  type        = any
}
variable "region_alias" {
  type    = string
  default = ""
}
variable "endpoints" {
  description = "A map of interface and/or gateway endpoints containing their properties and configurations"
  type        = any
  default     = {}
}
variable "tags" {
  description = "Tags"
  type        = any
  default     = {}
}