environment                    = "stage"
awscredsprofile                = "hitchkick"
primary_region                 = "us-east-2"
failover_region                = "us-east-1"
vpc_cidr_block_region_primary  = "10.0.0.0/16"
maxAZs                         = 3

aurora_global_primary_hosts  = 1
aurora_global_failover_hosts = 0