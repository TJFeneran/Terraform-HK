################################################################################
# Single-Region Aurora Cluster
################################################################################
provider "aws" {
  region = local.region
}

// Set locals
locals {
  region = var.region
}

// Retrieve vpcID parameter ('id-xxxxxxxxxxxxx') for this region from SSM Parameter Store
data "aws_ssm_parameter" "vpc-cidr" {
  name = "${var.default_vars.workload_name_abbr}-vpc-id"
}

// Create Aurora cluster in this region
resource "aws_rds_cluster" "db_cluster" {
  engine               = "aurora-postgresql"
  engine_version       = "15.4"
  master_username      = "root"
  master_password      = random_password.master.result
  cluster_identifier   = var.cluster_name
  db_subnet_group_name = aws_db_subnet_group.aurora_database.name
  skip_final_snapshot  = true

  // storage encryption
  kms_key_id        = aws_kms_key.clusterkey.arn
  storage_encrypted = true

  // don't keep up with future engine version upgrades on this resource
  lifecycle {
    ignore_changes = [engine_version]
  }

}

// Create Aurora instance(s) within new cluster
resource "aws_rds_cluster_instance" "db_instance" {
  count                = var.instances
  engine               = "aurora-postgresql"
  engine_version       = "15.4"
  identifier           = "instance-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.db_cluster.id
  instance_class       = "db.t4g.large"
  db_subnet_group_name = aws_db_subnet_group.aurora_database.name
  monitoring_interval  = 0
}

################################################################################
# Supporting Resources
################################################################################

// Generate a random master password
resource "random_password" "master" {
  length  = 20
  special = false
}

// Find all database subnets (Tags: {Tier = 'database'} )
data "aws_subnets" "database_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc-cidr.insecure_value]
  }
  tags = {
    Tier = "database"
  }
}

// Create a new database subnet group
resource "aws_db_subnet_group" "aurora_database" {
  subnet_ids = data.aws_subnets.database_subnets.ids

  tags = {
    Name = "${var.default_vars.workload_name} DB subnet group"
  }
}

// Get identity of local caller to AWS
data "aws_caller_identity" "current" {}

// KMS > RDS policy document
data "aws_iam_policy_document" "rds" {
  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        data.aws_caller_identity.current.arn,
      ]
    }
  }

  statement {
    sid = "Allow use of the key"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type = "Service"
      identifiers = [
        "monitoring.rds.amazonaws.com",
        "rds.amazonaws.com",
      ]
    }
  }
}

// Create KMS Key
resource "aws_kms_key" "clusterkey" {
  policy = data.aws_iam_policy_document.rds.json
  tags = {
    name = "${var.cluster_name}"
  }
}