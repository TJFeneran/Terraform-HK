# REGION-VPC OUTPUTS

output "vpc_id" {
  value = module.vpc_primary.vpc_id
}

output "private_subnets" {
  value = module.vpc_primary.private_subnets
}

output "public_subnets" {
  value = module.vpc_primary.public_subnets
}

output "database_subnets" {
  value = module.vpc_primary.database_subnets
}

output "route_table_private" {
  value = module.vpc_primary.route_table_private
}

output "route_table_public" {
  value = module.vpc_primary.route_table_public
}