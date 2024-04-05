# provision redshift cluster subnet group
module "redshift_cluster_subnet_group" {
    source = "/workspaces/lakehouse-formation/dbt-redshift-dw/module/redshift-cluster-subnet-group"
    redshift_cluster_subnet_group_name = "dbt-redshift-dw-redshift-subnet-group"
    vpc_subnet_ids = [
    "subnet-03f2de43489631598",  # Replace with the ID of your first subnet
    "subnet-0a31eae05e30f1882",  # Replace with the ID of your second subnet
  ]
    
}