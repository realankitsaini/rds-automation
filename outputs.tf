output "sandbox_cluster_endpoint" {
  value       = aws_rds_cluster.ephemeral_cluster.endpoint
  description = "The endpoint connection string for the ephemeral sandbox database cluster"
}

output "snapshot_source_utilized" {
  value       = aws_rds_cluster.ephemeral_cluster.snapshot_identifier
  description = "The exact snapshot ID that was used to provision this sandbox run"
}