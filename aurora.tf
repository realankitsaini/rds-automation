# 1. Ephemeral Cluster Core Restored using Conditional Snapshot Identification Logic
resource "aws_rds_cluster" "ephemeral_cluster" {
  cluster_identifier   = "pr-${var.pr_number}-aurora-sandbox"
  engine               = "aurora-mysql"
  engine_version       = "8.0"
  db_subnet_group_name = aws_db_subnet_group.ephemeral_subnet_group.name
  vpc_security_group_ids = [aws_security_group.ephemeral_sg.id]
  
  # Conditional Choice Logic: Evaluates your variable configuration input
  snapshot_identifier  = var.snapshot_selection_type == "CUSTOM" ? var.custom_snapshot_identifier : data.aws_db_snapshot.latest_sanitized_snapshot.id
  
  skip_final_snapshot  = true 

  tags = {
    Name         = "pr-${var.pr_number}-aurora-cluster"
    Environment  = "ephemeral"
    PullRequest  = var.pr_number
    AutoTeardown = "true"
  }
}

resource "aws_rds_cluster_instance" "ephemeral_instance" {
  identifier          = "pr-${var.pr_number}-instance"
  cluster_identifier  = aws_rds_cluster.ephemeral_cluster.id
  instance_class      = var.db_instance_class
  engine              = aws_rds_cluster.ephemeral_cluster.engine
  engine_version      = aws_rds_cluster.ephemeral_cluster.engine_version
  publicly_accessible = false
}