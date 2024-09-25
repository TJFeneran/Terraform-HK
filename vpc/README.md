# Multi-Region VPCs
## Should be first module deployed
### Resources Deployed:
* Subnets: Private, Public, Database
* Route Tables (private (default), public)
* VPC Endpoints (S3, DynamoDB, SSM)
 
### Usage:
* Run `terragrunt init` from root `/`
* `cd` to this directory
* `terragrunt apply`