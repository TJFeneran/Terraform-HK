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