provider "aws" {
    region = "us-east-1"
  
}

# provision athena db and glue crawler , assign proper permission to IAM role.
module "glue_crawler" {
    source = "/workspaces/lakehouse-formation/dbt-redshift-dw/module/glue-crawler"
    aws_glue_catalog_database = "dev_bronze"
    s3_bucket = "dbt-redshift-dw"
    aws_glue_crawler_name = "dbt-redshift-crawler"
    table_prefix = "ext_"
    csv_classifier_name = "dbt-redshift-csv-classifier"
    
}