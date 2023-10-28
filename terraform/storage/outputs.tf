output "fnf-rds-cluster_endpoint" {
  value = aws_rds_cluster.fnf-rds-cluster.endpoint
}

output "fnf-rds-cluster_master_password" {
  value = aws_rds_cluster.fnf-rds-cluster.master_password
  sensitive = true
}