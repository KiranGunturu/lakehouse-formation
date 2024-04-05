provider "aws" {
  region = "us-east-1" // Change this to your desired AWS region
}




resource "aws_redshift_cluster" "example_cluster" {
  cluster_identifier       = "dbt-redshit-dw"
  database_name            = "dev"
  master_username          = "admin"
  master_password          = "Password123" // Replace this with a secure password
  node_type                = "dc2.large" // Change this to your desired node type
  cluster_type             = "single-node" // Change this to "multi-node" if needed
  cluster_subnet_group_name = dbt-redshift-dw-redshift-subnet-group
  publicly_accessible      = true // Set to false if you want to limit access to your VPC
}
