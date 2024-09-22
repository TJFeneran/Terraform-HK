# HitchKick Terraform
Infrastructure-as-Code to deploy HitchKick AWS Resources

## Scope

1. VPCs
2. Subnets (Private & Public)
3. IGW / EIGW
4. Route Table(s) & Routes
5. VPC Endpoints

## Usage
Setup back-end for tfstate:
- (manual) Create S3 bucket
- (manual) Create DynamoDB table

Configure credentials

### Required: Select Workspace (prod | stage)
`terraform workspace select prod`

### Required: load environment variables using _var-file_ parameter as part of terraform invokation
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