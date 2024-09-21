# REGION-VPC OUTPUTS

output "vpc_id" {
  value       = aws_vpc.main.id
}

output "private_subnets" {
  value = aws_subnet.private_subnets
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "route_table_private" {
  value = aws_default_route_table.default_rt
}

output "route_table_public" {
  value = aws_route_table.public_rt
}