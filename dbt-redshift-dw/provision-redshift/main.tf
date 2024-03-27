provider "aws" {
  region = "us-east-1" // Change this to your desired AWS region
}

// Assuming you have existing VPC and subnet resources
data "aws_vpc" "existing_vpc" {
  id = "vpc-0372c600ce1716fbc" // Replace with your existing VPC ID
}

/*
data "aws_subnet" "existing_subnets" {
  vpc_id = data.aws_vpc.existing_vpc.id
}

resource "aws_redshift_subnet_group" "example_subnet_group" {
  count       = length(data.aws_subnet.existing_subnets.ids)
  name        = "example-subnet-group-${count.index}"
  description = "Example Redshift subnet group"

  subnet_ids = [data.aws_subnet.existing_subnets.ids[count.index]]
}
*/

data "aws_subnet" "existing_subnets" {
  vpc_id = data.aws_vpc.existing_vpc.id
}

resource "aws_redshift_subnet_group" "dbt_redshift_dw" {
  name        = "dbt-redshift-dw"
  description = "Example Redshift subnet group"
  subnet_ids  = [for subnet in data.aws_subnet.existing_subnets : subnet.id]
}


resource "aws_redshift_cluster" "example_cluster" {
  cluster_identifier       = "dbt-redshit-dw"
  database_name            = "dev"
  master_username          = "admin"
  master_password          = "Password123" // Replace this with a secure password
  node_type                = "dc2.large" // Change this to your desired node type
  cluster_type             = "single-node" // Change this to "multi-node" if needed
  cluster_subnet_group_name = aws_redshift_subnet_group.dbt_redshift_dw.name
  publicly_accessible      = true // Set to false if you want to limit access to your VPC
}
