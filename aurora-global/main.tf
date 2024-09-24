data "aws_ssm_parameter" "vpc-cidr-primary" {
  name = "vpc-cidr-primary"
}

data "aws_subnets" "database_subnets_primary" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc-cidr-primary.insecure_value]
  }

  tags = {
    Tier = "database"
  }

  provider = aws.primary
}

resource "aws_rds_cluster" "primary" {
  engine                    = aws_rds_global_cluster.auroraglobal.engine
  engine_version            = aws_rds_global_cluster.auroraglobal.engine_version
  cluster_identifier        = "cluster-primary"
  master_username           = "root"
  master_password           = random_password.master.result
  global_cluster_identifier = aws_rds_global_cluster.auroraglobal.id
  db_subnet_group_name      = aws_db_subnet_group.aurora_global_database_primary.name
  skip_final_snapshot       = true
  kms_key_id                = aws_kms_key.primary.arn

  lifecycle {
    ignore_changes = [engine_version]
  }

  provider = aws.primary
}

resource "aws_rds_cluster_instance" "primary" {
  count                = var.aurora_global_primary_hosts
  engine               = aws_rds_global_cluster.auroraglobal.engine
  engine_version       = aws_rds_global_cluster.auroraglobal.engine_version
  identifier           = "primary-cluster-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.primary.id
  instance_class       = "db.r7g.large"
  db_subnet_group_name = aws_db_subnet_group.aurora_global_database_primary.name
  monitoring_interval  = 0

  provider = aws.primary
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

resource "aws_kms_key" "primary" {
  policy   = data.aws_iam_policy_document.rds.json
  provider = aws.primary
}

resource "aws_db_subnet_group" "aurora_database" {
  subnet_ids = data.aws_subnets.database_subnets_primary.ids

  tags = {
    Name = "${var.workload_name} DB subnet group"
  }
  provider = aws.primary
}