# MAIN TF OUTPUTS

output "environment" {
  value = var.environment
}

output "aurora_primary_writer" {
  value = aws_rds_cluster.primary.endpoint
}

output "aurora_primary_reader" {
  value = aws_rds_cluster.primary.reader_endpoint
}

output "aurora_failover_writer" {
  value = aws_rds_cluster.failover.endpoint
}

output "aurora_failover_reader" {
  value = aws_rds_cluster.failover.reader_endpoint
}