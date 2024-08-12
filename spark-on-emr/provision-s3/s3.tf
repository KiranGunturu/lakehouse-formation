# provider configuration
provider "aws" {
    region = "us-east-1"
  
}

# provision S3 bucket to store raw data
module "s3_raw" {
    source = "/workspaces/lakehouse-formation/dbt-redshift-dw/module/s3"
    objects = ["raw/",
			"cleansed/"

        ]
    bucket = "spark-emr-data-processing"
    Environment =  "Dev"
}