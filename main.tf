
// use config file & profiles for creds local, secrets in gh actions

//////////////////////////////////////////////////////////////
// REFER TO backend.tf FOR terraform init CONFIG (has hardcoded region)
//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////
// REFER TO variables.tf FOR VARIABLES
//////////////////////////////////////////////////////////////

//configure provider
provider "aws" {
  default_tags {
    tags = {
      Environment = "${var.environment}"
      Terraform   = "true"
      Workload    = "${var.service_name}"
    }
  }
}

data "aws_availability_zones" "available" {}

//////////////////////////////////////////////////////////////
// RESOURCE CREATION
//////////////////////////////////////////////////////////////

// VPC
resource "aws_vpc" "main" {

  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = {
    Name = "${var.service_name} VPC"
  }

}

// Public Subnets
resource "aws_subnet" "public_subnets" {

  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.service_name} Public Subnet ${count.index + 1}"
  }
}

// Private Subnets
resource "aws_subnet" "private_subnets" {

  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

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
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_default_route_table.default_rt.id
}

// Route Table Associations - public subnets to new RT with IGW
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}
