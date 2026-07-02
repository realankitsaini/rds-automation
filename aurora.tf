# aurora.tf
# 1. Ephemeral Cluster Restored directly from your Manual Input Variable
resource "aws_rds_cluster" "ephemeral_cluster" {
  cluster_identifier   = var.db_cluster_name
  engine               = "aurora-postgresql"
  port                 = 5432   # Default PostgreSQL network port allocation
  
  db_subnet_group_name   = aws_db_subnet_group.ephemeral_subnet_group.name
  vpc_security_group_ids = [aws_security_group.ephemeral_sg.id]
  
  # Maps straight to your manual terminal input parameter string
  snapshot_identifier  = var.target_snapshot_identifier
  
  skip_final_snapshot  = true 

  tags = {
    Name         = var.db_cluster_name
    Environment  = "ephemeral"
    PullRequest  = var.pr_number
    AutoTeardown = "true"
  }
}

# 2. Ephemeral DB Compute Node Instance
resource "aws_rds_cluster_instance" "ephemeral_instance" {
  identifier          = "${var.db_cluster_name}-instance"
  cluster_identifier  = aws_rds_cluster.ephemeral_cluster.id
  instance_class      = var.db_instance_class
  engine              = aws_rds_cluster.ephemeral_cluster.engine
  engine_version      = aws_rds_cluster.ephemeral_cluster.engine_version
  publicly_accessible = false
}