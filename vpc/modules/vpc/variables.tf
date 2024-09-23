variable "default_vars" {
  description = "Contains all default variables from root common_vars.yaml"
  type = any
}
variable "region_alias" {
  type = string
  default = ""
}