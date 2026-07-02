variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The target AWS region for deployment"
}

variable "pr_number" {
  type        = string
  description = "The Pull Request ID used to uniquely tag and isolate this ephemeral database resource"
}

variable "db_cluster_name" {
  type        = string
  description = "Enter the name you want to assign to this new sandbox cluster"
}

variable "target_snapshot_identifier" {
  type        = string
  description = "Enter the exact AWS Snapshot Identifier or ARN you want to clone from"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t4g.medium"
  description = "The compute tier size applied to short-lived ephemeral sandboxes"
}