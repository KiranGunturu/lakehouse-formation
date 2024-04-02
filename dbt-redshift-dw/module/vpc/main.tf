provider "aws" {
    region = "us-east-1"
  
}

variable "subnet_cidr_block" {
  type = string
  description = "list of subnet range"

  
}

data "external" "cidr_checker" {
  program = ["python", "/workspaces/lakehouse-formation/dbt-redshift-dw/module/vpc/cidr_check.py"]
  query = {
    new_cidr_block = var.subnet_cidr_block # Specify the new CIDR block you want to create
  }
}

variable "vpc_name" {
    description = "name of the VPC"
    default = "my-vpc"
  
}

variable "cidr" {
    default = "172.31.0.0/20"
  
}

variable "availability_zones" {
  description = "The list of availability zones to deploy subnets in."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]  # Change this to your desired AZs
}



resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr

    tags = {
    Name = var.vpc_name
  }
  
}

resource "aws_subnet" "public_subnets" {
  count                  = length(var.availability_zones)
  vpc_id                 = aws_vpc.myvpc.id
  availability_zone      = var.availability_zones[count.index]
  cidr_block             = data.external.cidr_checker.result["adjusted_cidr_block"]
  map_public_ip_on_launch = true


}


resource "aws_subnet" "private_subnets" {
  count                  = length(var.availability_zones)
  vpc_id                 = aws_vpc.myvpc.id
  cidr_block             = data.external.cidr_checker.result["adjusted_cidr_block"]
  availability_zone      = var.availability_zones[count.index]


}

