# provider configuration
provider "aws" {
    region = "us-east-1"
  
}

# provision S3 bucket to store raw data
module "s3_raw" {
    source = "/workspaces/lakehouse-formation/dbt-redshift-dw/module/s3"
    objects = ["accounts/",
            "channels/",
            "currencies/",
            "dates/",
            "investment_types/",
            "loans/",
            "locations/",
            "transaction_types/",
            "fact_customer_interactions/",
            "fact_daily_balances/",
            "fact_investments/",
            "fact_loans/",
            "fact_transactions/"

        ]
    bucket = "dbt-redshift-dw"
    Environment =  "Dev"

    
}