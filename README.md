#HitchKick Terraform | Infrastructure-as-Code to deploy HitchKick AWS Resources


##Scope

Network Foundation
VPCs
Subnets (Private & Public)
IGW / EIGW
Route Table(s) & Routes
VPC Endpoints

##Usage
###Required: Select Workspace
terraform workspace select [**prod** or **stage**]

###Required: load environment variables using var-file parameter
terraform apply -var-file="prod.tfvars"

##Prerequisites
Terraform CLI
AWS CLI

##Credentials
Local (default config file):
    - (manual) set a profile for each environment

Remote:
    - TBD

##Environment Variables (tfvars)