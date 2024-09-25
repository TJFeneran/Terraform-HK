# Single-Region Aurura Cluster with _n_ Instances

### Init 
* Run `terragrunt init` from root `/`
* `cd` to this directory

### vars
* Open & edit specific vars file for existing resource (based on name variable)
* OR copy `example.tfvars` to new file and edit variables, and deploy new cluster

### `terragrunt apply -var-file=newaurora.tfvars`
* Always include a `.tfvars` file here, see `example.tfvars` for example