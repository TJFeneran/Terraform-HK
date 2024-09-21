terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_availability_zones" "available" {}

// S3 Gateway VPCe
resource "aws_vpc_endpoint" "vpce_s3" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
  
  tags = {
    Name: "${var.workload_name} S3 Gateway VPC Endpoint"
  }
}