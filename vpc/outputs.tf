# REGION-VPC OUTPUTS

output "primary_region_vpc_id" {
  value = module.vpc_primary.vpc_id
}

output "failover_region_vpc_id" {
  value = module.vpc_failover.vpc_id
}