# HitchKick Terraform
Infrastructure-as-Code to deploy HitchKick AWS Resources

## Scope
Primary & Secondary AWS Regions

* VPCs
* Subnets (Private & Public & Database)
* IGW / EIGW
* Route Table(s) & Routes
* VPC Endpoints

## Usage
### 1. Configure credentials
Local (default config file):
* (manual) set a profile for each environment
Remote:
* TBD

### 2. Setup remote back-end for *tfstate*:
* S3 Bucket 
  - Use existing bucket, or create new
  - If new: enable object versioning, others default
* DynamoDB Table
  - Use existing table, or create new
  - If new: Capacity type: On-Demand (1 RCU / 1 WCU), PK: *LockID* (String)
  - *TODO*: table policy
* Assign values for _bucket name_ and _dynamodb table_.
* Confirm _AWS Region_ (for tfstate bucket only) and any other variables in `backend.tf`

### 3. `terraform init`
Will load `backend.tf` during init, and configure the remote storage for *tfstate*

### Required: Select Workspace (prod | stage)
4. `terraform workspace select prod`

_*switch workspaces as necessary*_

### Required: load environment variables using _var-file_ parameter for nearly all terraform invokation
5. `terraform apply -var-file="prod.tfvars"`

## Prerequisites
* Terraform CLI
* AWS CLI
* AWS Environment with Proper Credentials

## Environment Variables (tfvars)
Variables for each environment 
* prod: `prod.tfvars`
* stage: `stage.tfvars`