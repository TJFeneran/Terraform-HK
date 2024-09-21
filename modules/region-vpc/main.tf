terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_availability_zones" "available" {}

// VPC
resource "aws_vpc" "main" {

  cidr_block                       = var.vpc_cidr_block
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true
  instance_tenancy                 = "default"

  tags = {
    Name   = "${var.service_name} VPC"
    Region = var.region
  }
}

// Public Subnets
resource "aws_subnet" "public_subnets" {

  count                           = var.maxAZs <= length(data.aws_availability_zones.available.names) ? var.maxAZs : length(data.aws_availability_zones.available.names)
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 6, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.service_name} Public Subnet ${count.index + 1}"
  }
}

// Private Subnets
resource "aws_subnet" "private_subnets" {

  count                           = var.maxAZs <= length(data.aws_availability_zones.available.names) ? var.maxAZs : length(data.aws_availability_zones.available.names)
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 6, count.index + var.maxAZs)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + var.maxAZs)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.service_name} Private Subnet ${count.index + 1}"
  }
}

// IGW 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.service_name} Internet Gateway"
  }
}

// EGRESS-ONLY IGW
resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.service_name} Egress Gateway"
  }
}

// NGW or fck-nat


// Route Table (default) 
resource "aws_default_route_table" "default_rt" {

  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "${var.service_name} Private Route Table (Default)"
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
    Name = "${var.service_name} Public Route Table"
  }
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