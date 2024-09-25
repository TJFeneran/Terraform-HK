# Multi-Region VPC Setup
## VPC resources in both regions
### Should be first module deployed

* Subnets: Private, Public, Database
* Route Tables (private (default), public)
* VPC Endpoints (S3, DynamoDB, SSM)
 
### Usage
* Run `terragrunt init` from root `/`
* `cd` to this directory
* `terragrunt apply`