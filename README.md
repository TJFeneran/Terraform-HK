HitchKick Terraform | Infrastructure-as-Code to deploy HitchKick AWS Resources

Two regions
VPCs
Subnets (Private & Public)
IGW / EIGW
Route Table(s) & Routes

terraform workspaces:
stage
prod

ex usage:
terraform workspace select prod
terraform apply -var-file="prod.tfvars"

must use workspace and tfvars file parameter required

---
latest:
add module region_vpc_endpoints 
s3 route
in route table / route asssociation