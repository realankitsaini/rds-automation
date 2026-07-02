provider "aws" {
  region = var.aws_region
}

# 1. Continues to fetch the latest snapshot just in case it is requested
data "aws_db_snapshot" "latest_sanitized_snapshot" {
  db_cluster_identifier = var.production_cluster_identifier
  most_recent           = true
  snapshot_type         = "manual" 
}

# 2. Ephemeral Sandbox Dedicated VPC
resource "aws_vpc" "ephemeral_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "pr-${var.pr_number}-vpc"
    Environment = "ephemeral"
  }
}

# 3. Subnet A
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.ephemeral_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = "pr-${var.pr_number}-subnet-a"
    Environment = "ephemeral"
  }
}

# 4. Subnet B
resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.ephemeral_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name        = "pr-${var.pr_number}-subnet-b"
    Environment = "ephemeral"
  }
}

# 5. Strictly Isolated DB Subnet Group
resource "aws_db_subnet_group" "ephemeral_subnet_group" {
  name        = "pr-${var.pr_number}-subnet-group"
  description = "Subnet association mapping for Ephemeral Sandbox PR ${var.pr_number}"
  subnet_ids  = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

# 6. Database Firewall (Security Group)
resource "aws_security_group" "ephemeral_sg" {
  name        = "pr-${var.pr_number}-sg"
  description = "Strict firewall rules isolating sandbox database traffic"
  vpc_id      = aws_vpc.ephemeral_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.ephemeral_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}