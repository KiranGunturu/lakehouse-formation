# provider configuration
provider "aws" {
    region = "us-east-1"
  
}

# provision S3 bucket to store raw data
module "s3_raw" {
    source = "/workspaces/terraform/spotify-analytics-on-aws-athena/module/s3"
    objects = ["raw_data/landing/",
            "raw_data/archive/",
            "transformed_data/albums/",
            "transformed_data/artists/",
            "transformed_data/songs/"
        ]
    bucket = "spotify-analytics-raw-data"
    Environment =  "Dev"
  
}

# provision S3 bucket to store transformed data
module "s3_cleansed" {
    source = "/workspaces/terraform/spotify-analytics-on-aws-athena/module/s3"
    bucket = "spotify-analytics-cleansed-data"
    Environment =  "Dev"
  
}
