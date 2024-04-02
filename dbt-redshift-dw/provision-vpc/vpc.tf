# provision athena db and glue crawler , assign proper permission to IAM role.
module "vpc" {
    source = "/workspaces/lakehouse-formation/dbt-redshift-dw/module/vpc"
    cidr = "172.31.0.0/20"
    subnet_cidr_block     = "172.31.0.0/24"
    vpc_name = "dbt-redshift-dw"
    availability_zones = ["us-east-1a"]
    
}