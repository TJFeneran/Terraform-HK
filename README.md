# HitchKick Terraform
Infrastructure-as-Code to deploy HitchKick AWS Resources

## Scope

Network Foundation
VPCs
Subnets (Private & Public)
IGW / EIGW
Route Table(s) & Routes
VPC Endpoints

## Usage
Setup back-end for tfstate:
    - (manual) Create S3 bucket
    - (manual) Create DynamoDB table





### Required: Select Workspace
`terraform workspace select [_prod_ or _stage_]`

### Required: load environment variables using _var-file_ parameter
`terraform apply -var-file="prod.tfvars"`

## Prerequisites
Terraform CLI
AWS CLI

## Credentials
Local (default config file):
    - (manual) set a profile for each environment

Remote:
    - TBD

## Environment Variables (tfvars)