# test getting values from parameter store


data "aws_ssm_parameter" "vpc-cidr-primary" {
  name = "vpc-cidr-primary"
}

output "vpc-cidr-primary" {
  value     = data.aws_ssm_parameter.vpc-cidr-primary
  sensitive = true
}