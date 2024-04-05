# provision redshift cluster, IAM with access to s3 bucket.
module "redshift" {
    source = "/workspaces/lakehouse-formation/dbt-redshift-dw/module/redshift"
    iam_role_name = "dbt-redshift-dbt-redshift-s3"
    s3_bucket_name = "dbt-redshift-dw"
    cluster_name = "dbt-redshit-dw"
    database_name = "dev"
    db_username = "admin"
    db_password = "Password123"
    node_type = "dc2.large"
    cluster_type = "single-node"
    cluster_subnet_group_name = "dbt-redshift-dw-redshift-subnet-group"
    publicly_accessible = "true"

}

