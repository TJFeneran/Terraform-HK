terraform {
  backend "s3" {
    bucket         = "hk-tfstate-backend"
    region         = "us-east-2"
    key            = "s3-github-actions/terraform.tfstate" // can/should do <env>/terraform.state, 
    encrypt = true
    dynamodb_table = "aws-tf-state"
  }

  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source = "hashicorp/aws"
    }
  }
}