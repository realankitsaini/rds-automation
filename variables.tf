variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The target AWS region for deployment"
}

variable "pr_number" {
  type        = string
  description = "The Pull Request ID passed dynamically from the GitHub Actions runner context"
}

variable "production_cluster_identifier" {
  type        = string
  default     = "production-aurora-cluster"
  description = "The identifier of the live production cluster used to locate baseline snapshots"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t4g.medium"
  description = "The cost-efficient compute tier size applied to short-lived ephemeral sandboxes"
}

# =========================================================================
# NEW ENHANCED SNAPSHOT SELECTION VARIABLES
# =========================================================================

variable "snapshot_selection_type" {
  type        = string
  default     = "LATEST"
  description = "Set to 'LATEST' to use the automatic most-recent snapshot, or 'CUSTOM' to provide a specific snapshot identifier"

  validation {
    condition     = contains(["LATEST", "CUSTOM"], var.snapshot_selection_type)
    error_message = "The snapshot_selection_type variable must be set to either 'LATEST' or 'CUSTOM'."
  }
}

variable "custom_snapshot_identifier" {
  type        = string
  default     = ""
  description = "The specific AWS Snapshot ID or ARN you want to clone from (Only required if snapshot_selection_type is set to 'CUSTOM')"
}