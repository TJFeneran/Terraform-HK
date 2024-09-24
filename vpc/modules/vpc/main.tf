################################################################################
# VPC MODULE
################################################################################

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

locals {
  default_vars = var.default_vars
  region = lookup(local.default_vars.regions, var.region_alias, "")
}

data "aws_availability_zones" "available" {}

// VPC
resource "aws_vpc" "main" {

  cidr_block                       = local.region.vpc_cidr_block
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true
  instance_tenancy                 = "default"

  tags = {
    Name   = "${local.default_vars.workload_name} VPC"
  }
}

// Public Subnets
resource "aws_subnet" "public_subnets" {

  count                           = local.region.maxAZs <= length(data.aws_availability_zones.available.names) ? local.region.maxAZs : length(data.aws_availability_zones.available.names)
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 6, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${local.default_vars.workload_name} Public Subnet ${count.index + 1}"
    Tier = "public"
  }
}

// Private Subnets
resource "aws_subnet" "private_subnets" {

  count                           = local.region.maxAZs <= length(data.aws_availability_zones.available.names) ? local.region.maxAZs : length(data.aws_availability_zones.available.names)
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 6, count.index + local.region.maxAZs)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + local.region.maxAZs)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${local.default_vars.workload_name} Private Subnet ${count.index + 1}"
    Tier = "private"
  }
}

// Database Subnets
resource "aws_subnet" "database_subnets" {

  count                           = local.region.maxAZs <= length(data.aws_availability_zones.available.names) ? local.region.maxAZs : length(data.aws_availability_zones.available.names)
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 6, count.index + (local.region.maxAZs * 2))
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + (local.region.maxAZs * 2))
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${local.default_vars.workload_name} Database Subnet ${count.index + 1}"
    Tier = "database"
  }
}

// IGW 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.default_vars.workload_name} Internet Gateway"
  }
}

// EGRESS-ONLY IGW
resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.default_vars.workload_name} Egress Gateway"
  }
}

// NGW or fck-nat


// Route Table (default) 
resource "aws_default_route_table" "default_rt" {

  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "${local.default_vars.workload_name} Private Route Table (Default)"
  }
}

// Route Table (public)
resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.eigw.id
  }

  tags = {
    Name = "${local.default_vars.workload_name} Public Route Table"
  }
}

// Route Table Associations - database subnets to default/main RT
resource "aws_route_table_association" "database_subnet_association" {
  count          = length(aws_subnet.database_subnets)
  subnet_id      = element(aws_subnet.database_subnets[*].id, count.index)
  route_table_id = aws_default_route_table.default_rt.id
}

// Route Table Associations - private subnets to default/main RT
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_default_route_table.default_rt.id
}

// Route Table Associations - public subnets to new RT with IGW
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

################################################################################
# VPC Endpoint(s)
################################################################################

// Security Groups for Interface Endpoints
resource "aws_security_group" "sg_vpces" {
    name = "VPC Endpoints"
    description = "Security Group applied to interface VPC Endpoints"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

}

data "aws_vpc_endpoint_service" "this" {
  for_each = var.endpoints

  service      = lookup(each.value, "service", null)
  service_name = lookup(each.value, "service_name", null)

  filter {
    name   = "service-type"
    values = [lookup(each.value, "service_type", "Interface")]
  }
}

resource "aws_vpc_endpoint" "this" {
  for_each = var.endpoints

  vpc_id            = aws_vpc.main.id
  service_name      = data.aws_vpc_endpoint_service.this[each.key].service_name
  vpc_endpoint_type = lookup(each.value, "service_type", "Interface")
  auto_accept       = lookup(each.value, "auto_accept", null)
  security_group_ids  = lookup(each.value, "service_type", "Interface") == "Interface" ? distinct(concat(aws_security_group.sg_vpces[*].id)) : null
  subnet_ids          = lookup(each.value, "service_type", "Interface") == "Interface" ? distinct(concat(aws_subnet.public_subnets[*].id)) : null
  route_table_ids     = lookup(each.value, "service_type", "Interface") == "Gateway" ? distinct(concat(aws_default_route_table.default_rt[*].id, aws_route_table.public_rt[*].id)) : null
  policy              = lookup(each.value, "policy", null)
  private_dns_enabled = lookup(each.value, "service_type", "Interface") == "Interface" ? lookup(each.value, "private_dns_enabled", null) : null

  tags = merge(var.tags, lookup(each.value, "tags", {}))

}