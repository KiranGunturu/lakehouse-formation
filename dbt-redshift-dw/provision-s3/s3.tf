# provider configuration
provider "aws" {
    region = "us-east-1"
  
}

# provision S3 bucket to store raw data
module "s3_raw" {
    source = "/workspaces/lakehouse-formation/dbt-redshift-dw/module/s3"
    objects = ["landing/",
			"landing/accounts/",
            "landing/channels/",
            "landing/currencies/",
            "landing/dates/",
            "landing/investment_types/",
            "landing/loans/",
            "landing/locations/",
            "landing/transaction_types/",
            "landing/fact_customer_interactions/",
            "landing/fact_daily_balances/",
            "landing/fact_investments/",
            "landing/fact_loans/",
            "landing/fact_transactions/"

        ]
    bucket = "dbt-redshift-dw"
    Environment =  "Dev"

    
}