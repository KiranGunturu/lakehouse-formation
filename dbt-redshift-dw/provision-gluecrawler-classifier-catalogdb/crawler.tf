provider "aws" {
    region = "us-east-1"
  
}

# provision athena db and glue crawler , assign proper permission to IAM role.
module "glue_crawler" {
    source = "/workspaces/lakehouse-formation/dbt-redshift-dw/module/glue-crawler"
    aws_glue_catalog_database = "dbt-redshift-dev"
    s3_bucket = "dbt-redshift-dw"
    aws_glue_crawler_name = "dbt-redshift-dw-crawler"
    table_prefix = "ext_"
    csv_classifier_name = "dbt-redshift-csv-classifier"
    s3_folders=[
        "s3://dbt-redshift-dw/landing/accounts/",
        "s3://dbt-redshift-dw/landing/channels/",
        "s3://dbt-redshift-dw/landing/currencies/",
        "s3://dbt-redshift-dw/landing/dates/",
        "s3://dbt-redshift-dw/landing/fact_customer_interactions/",
        "s3://dbt-redshift-dw/landing/fact_daily_balances/",
        "s3://dbt-redshift-dw/landing/fact_investments/",
        "s3://dbt-redshift-dw/landing/fact_loans/",
        "s3://dbt-redshift-dw/landing/fact_transactions/",
        "s3://dbt-redshift-dw/landing/investment_types/",
        "s3://dbt-redshift-dw/landing/loans/",
        "s3://dbt-redshift-dw/landing/locations/",
        "s3://dbt-redshift-dw/landing/transaction_types/",
        "s3://dbt-redshift-dw/landing/customers/"
        ]
    
}