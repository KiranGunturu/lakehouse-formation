# provider configuration
provider "aws" {
    region = "us-east-1"
  
}

# provision S3 bucket to store raw data
module "s3_raw" {
    source = "/workspaces/terraform/spotify-analytics-on-aws-athena/module/s3"
    s3_folder_path = "raw-data/"
    bucket = "spotify-analytics-raw-data"
    Environment =  "Dev"
  
}

# provision S3 bucket to store transformed data
module "s3_cleansed" {
    source = "/workspaces/terraform/spotify-analytics-on-aws-athena/module/s3"
    s3_folder_path = "cleansed-data/"
    bucket = "spotify-analytics-cleansed-data"
    Environment =  "Dev"
  
}
