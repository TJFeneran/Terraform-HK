# HitchKick Terraform
Infrastructure-as-Code to deploy HitchKick AWS Resources

## Scope

* VPCs
* Subnets (Private & Public)
* IGW / EIGW
* Route Table(s) & Routes
* VPC Endpoints

## Usage
### 1. Setup remote back-end for *tfstate*:
* (manual) Create S3 bucket
  - enable object versioning, others default
  - assign bucket name in `backend.tf`
* (manual) Create DynamoDB table
  - Name: *aws-tf-state*
  - Capacity type: On-Demand (1 RCU / 1 WCU)
  - PK: *LockID (String)*
  - *TODO*: table policy
### 2. Configure credentials
### 3. `terraform init`
Will load `backend.tf` during init, and configure the remote storage for *tfstate*

### Required: Select Workspace (prod | stage)
4. `terraform workspace select prod`

### Required: load environment variables using _var-file_ parameter as part of terraform invokation
5. `terraform apply -var-file="prod.tfvars"`

## Prerequisites
* Terraform CLI
* AWS CLI

## Credentials
Local (default config file):
* (manual) set a profile for each environment

Remote:
* TBD

## Environment Variables (tfvars)
Variables for each environment 
* prod: `prod.tfvars`
* stage: `stage.tfvars`
  