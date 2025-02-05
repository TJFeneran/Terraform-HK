# HitchKick Terraform
Infrastructure-as-Code to deploy HitchKick AWS Resources

## Prerequisites
* Terraform CLI
* Terragrunt CLI
* AWS CLI with proper credentials to deploy

## Scope
* VPCs
* Subnets (Private & Public & Database)
* IGW / EIGW
* Route Table(s) & Routes
* VPC Endpoints
* Aurora (Global or Single-region)

## Common Variables
* `common_vars.yaml` in root

## Formatting
* `terragrunt hclfmt`
* `terraform fmt`

## Usage
### 1. Configure credentials (Local)
* `default` aws creds profile
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

### 4. Deploy `vpc` module first
* `cd vpc` > `terragrunt apply`
* **Note:** `tfvars` paramter is **not** needed for the `vpc` module

### 5. Deploy other modules as needed
* `cd` to other modues (ex: `aurora-global`).
* Pass a `.tfvars` file for each distinct resource - see `example.tfvars` in each module for more info 
* `terragrunt plan|apply|destroy var-file=<varfilename>.tfvars`


