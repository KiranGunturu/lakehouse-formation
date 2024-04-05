provider "aws" {
    region = "us-east-1"
  
}

variable "private_subnet_cidr_block" {
  type = string
  description = "list of subnet range"

  
}

variable "public_subnet_cidr_block" {
  type = string
  description = "list of subnet range"

  
}
/*
data "external" "cidr_checker" {
  program = ["python", "/workspaces/lakehouse-formation/dbt-redshift-dw/module/vpc/cidr_check.py"]
  query = {
    new_cidr_block = var.subnet_cidr_block # Specify the new CIDR block you want to create
  }
}*/

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

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "${var.vpc_name}-publicroutetable"
    # Add other tags if needed
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "${var.vpc_name}-privateroutetable"
    # Add other tags if needed
  }
}

resource "aws_subnet" "public_subnets" {
  count                  = length(var.availability_zones)
  vpc_id                 = aws_vpc.myvpc.id
  availability_zone      = var.availability_zones[count.index]
  cidr_block             = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-publicsubnet-${var.availability_zones[count.index]}"
    # Add other tags if needed
  }


}

resource "aws_route_table_association" "public_subnet_association" {
  count             = length(var.availability_zones)
  subnet_id         = aws_subnet.public_subnets[count.index].id
  route_table_id    = aws_route_table.public_route_table.id
}


resource "aws_subnet" "private_subnets" {
  count                  = length(var.availability_zones)
  vpc_id                 = aws_vpc.myvpc.id
  cidr_block             = var.private_subnet_cidr_block
  availability_zone      = var.availability_zones[count.index]
    tags = {
    Name = "${var.vpc_name}-privatesubnet-${var.availability_zones[count.index]}"
    # Add other tags if needed
  }


}

resource "aws_route_table_association" "private_subnet_association" {
  count             = length(var.availability_zones)
  subnet_id         = aws_subnet.private_subnets[count.index].id
  route_table_id    = aws_route_table.private_route_table.id
}


# Create S3 endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.myvpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  route_table_ids   = [aws_route_table.private_route_table.id] # Associate with a route table
    tags = {
    Name = "${var.vpc_name}-vpcs3"
    # Add other tags if needed
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
    # Add other tags if needed
  }
}

# Create route in the public route table to connect to the Internet Gateway
resource "aws_route" "public_route_to_igw" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0" # Internet destination
  gateway_id             = aws_internet_gateway.my_igw.id
}

