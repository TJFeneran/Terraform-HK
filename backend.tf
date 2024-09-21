terraform {
  backend "s3" {
    bucket         = "hitchkick-tfstate"
    region         = "us-east-2"
    key            = "terraform.tfstate"
    encrypt        = true
    dynamodb_table = "aws-tf-state"
  }

  required_version = ">=0.13.1"
  required_providers {
    aws = {
      version = ">= 3.6.3"
      source  = "hashicorp/aws"
    }
  }
}