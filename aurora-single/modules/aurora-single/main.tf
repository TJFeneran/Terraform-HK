################################################################################
# Single-Region Aurora Cluster
################################################################################
provider "aws" {
  region = local.region
}

data "aws_ssm_parameter" "vpc-cidr" {
  name = "vpc-cidr-${var.region}"
}

data "aws_subnets" "database_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc-cidr.insecure_value]
  }

  tags = {
    Tier = "database"
  }
}

locals {
  region = lookup({ }, var.region, "")  
}

resource "aws_rds_cluster" "db_cluster" {
  engine                    = "aurora-postgresql"
  engine_version            = "15.4"
  master_username           = "root"
  master_password           = random_password.master.result
  cluster_identifier        = var.cluster_name
  db_subnet_group_name      = aws_db_subnet_group.aurora_database.name
  skip_final_snapshot       = true
  kms_key_id                = aws_kms_key.aurorakey.arn

  lifecycle {
    ignore_changes = [engine_version]
  }

}

resource "aws_rds_cluster_instance" "db_instance" {
  count                = var.instances
  engine               = "aurora-postgresql"
  engine_version       = "15.4"
  identifier           = "instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.db_cluster.id
  instance_class       = "db.r7g.large"
  db_subnet_group_name = aws_db_subnet_group.aurora_database.name
  monitoring_interval  = 0
}

################################################################################
# Supporting Resources
################################################################################

resource "random_password" "master" {
  length  = 20
  special = false
}

data "aws_caller_identity" "current" {}
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

resource "aws_kms_key" "aurorakey" {
  policy   = data.aws_iam_policy_document.rds.json
}

resource "aws_db_subnet_group" "aurora_database" {
  subnet_ids = data.aws_subnets.database_subnets.ids

  tags = {
    Name = "${var.workload_name} DB subnet group"
  }
  
}