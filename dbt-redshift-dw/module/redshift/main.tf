provider "aws" {
  region = "us-east-1" // Change this to your desired AWS region
}

variable "iam_role_name" {
  description = "name of the IAM role name"
  
}
variable "s3_bucket_name" {
  description = "name of the s3 bucket"
  
}
# Create IAM policy
resource "aws_iam_policy" "redshift_s3_access_policy" {
  name        = "redshift_s3_access_policy"
  description = "Allows access to S3 buckets for Redshift cluster"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource  = [
          "arn:aws:s3:::${var.s3_bucket_name}/*",
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      }
    ]
  })
}

# Create IAM role
resource "aws_iam_role" "redshift_s3_access_role" {
  name               = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Attach IAM policy to IAM role
resource "aws_iam_policy_attachment" "redshift_s3_access_attachment" {
  name       = "redshift_s3_access_attachment"
  policy_arn = aws_iam_policy.redshift_s3_access_policy.arn
  roles      = [aws_iam_role.redshift_s3_access_role.name]
}

variable "cluster_name" {
    description = "name of the redshift cluster"
  
}

variable "database_name" {
    description = "name of the database"
  
}

variable "db_username" {
    description = "username of the database"
  
}

variable "db_password" {
    description = "database password"
  
}

variable "node_type" {
    description = "provide the type of the node"
  
}

variable "cluster_type" {
    description = "type of the cluster"
  
}

variable "publicly_accessible" {
    description = "do want to our redshift cluster to be avaialble outside of VPC?"
  
}

variable "cluster_subnet_group_name" {
    description = "name of the cluster subnet group"
  
}
resource "aws_redshift_cluster" "example_cluster" {
  cluster_identifier       = var.cluster_name
  database_name            = var.database_name
  master_username          = var.db_username
  master_password          = var.db_password
  node_type                = var.node_type
  cluster_type             = var.cluster_type
  cluster_subnet_group_name = var.cluster_subnet_group_name
  publicly_accessible      = var.publicly_accessible
  skip_final_snapshot = true
  final_snapshot_identifier = "foo"
  iam_roles = [aws_iam_role.redshift_s3_access_role.arn]
}


