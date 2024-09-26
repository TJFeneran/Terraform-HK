################################################################################
# S3 Bucket
################################################################################
provider "aws" {
  region = local.region
}

// Set locals
locals {
  region = var.region
  policy = var.policy
}


resource "random_id" "bucket" {
  byte_length = 8
}

// S3 Bucket for event photo / video
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.default_vars.workload_name_abbr}-${var.bucket_name}-${random_id.bucket.hex}"
  tags = {
    Name        = "${var.default_vars.workload_name}"
    Environment = "${var.default_vars.environment}"
    Description = "${var.description}"
    Terraform = "true"
  }
}