workload_name                  = "HitchKick"
environment                    = "stage"
awscredsprofile                = "hitchkick"
primary_region                 = "us-east-2"
failover_region                = "us-east-1"
vpc_cidr_block_region_primary  = "10.0.0.0/16"
vpc_cidr_block_region_failover = "10.1.0.0/16"
maxAZs                         = 3