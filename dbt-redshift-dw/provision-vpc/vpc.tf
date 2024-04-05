# provision athena db and glue crawler , assign proper permission to IAM role.
module "vpc" {
    source = "/workspaces/lakehouse-formation/dbt-redshift-dw/module/vpc"
    cidr = "120.31.3.0/24" # gives 256 IPs
    public_subnet_cidr_block     = "120.31.3.0/26" # 32-26=6. 2^6=64. allocate 64 ips
    private_subnet_cidr_block     = "120.31.3.64/26" # Start from .64, 2^6=64 allocate 64 ips to private subnet
    vpc_name = "dbt-redshift-dw"
    availability_zones = ["us-east-1a"]
    
}