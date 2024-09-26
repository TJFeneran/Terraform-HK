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

variable "bucket_name" {
  description = "S3 bucket name (no spaces or underscores)"
  type        = string
  default     = ""
}

variable "policy" {
  description = "bucket policy"
  type        = string
  default     = ""
}

variable "description" {
  description = "Bucket Description"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to add"
  type        = map(any)
  default     = {}
}