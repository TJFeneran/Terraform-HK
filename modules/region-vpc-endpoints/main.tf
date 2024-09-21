terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_availability_zones" "available" {}

// S3 Gateway VPCe
resource "aws_vpc_endpoint" "s3" {
    vpc_id            =  var.vpc_id
    workload_name      = "com.amazonaws.${var.region}.s3"
    vpc_endpoint_type = "Gateway"

    private_dns_enabled = true
    
    tags = {
        Name   = "${var.workload_name} S3 VPC Endpoint"
        Region = var.region
    }
}