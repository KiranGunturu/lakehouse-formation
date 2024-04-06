# provision redshift cluster subnet group
module "redshift_cluster_subnet_group" {
    source = "/workspaces/lakehouse-formation/dbt-redshift-dw/module/redshift-cluster-subnet-group"
    redshift_cluster_subnet_group_name = "dbt-redshift-dw-redshift-subnet-group"
    vpc_subnet_ids = [
    "subnet-0a86add1e55726675",  # Replace with the ID of your first subnet
    "subnet-017dfb15ca68a52e5",  # Replace with the ID of your second subnet
  ]
    
}