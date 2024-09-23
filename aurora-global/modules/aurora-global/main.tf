terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  
  config = {
    bucket = "hitchkick-tfstate"
    key = "vpc/terraform.tfstate"
    region = "us-east-2"
  }

}

output "test" {
    value = "test" //data.terraform_remote_state.vpc.module.vpc_failover.aws_internet_gateway.igw
}