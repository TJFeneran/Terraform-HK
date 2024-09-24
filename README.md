# HitchKick Terraform
Infrastructure-as-Code to deploy HitchKick AWS Resources

## Scope
* VPCs
* Subnets (Private & Public & Database)
* IGW / EIGW
* Route Table(s) & Routes
* VPC Endpoints
* Aurora (Global or Single-region)

## Usage
### 1. Configure credentials
Local (default config file):
* (manual) set a profile
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

### 3. `terragrunt init` in root
Will generate `backend.tf`, configure *tfstate* remote storage

### 4. move to subdirectory module to deploy
`cd <module to deploy>`

### 5. `terraform plan|apply|destroy`

## Prerequisites
* Terraform CLI
* AWS CLI
* AWS Environment with Proper Credentials

## Common Variables
* /common_vars.yaml