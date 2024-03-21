# provider configuration
provider "aws" {
    region = "us-east-1"
  
}

# provision athena db and glue crawler , assign proper permission to IAM role.
module "lambda-raw" {
    source = "/workspaces/lakehouse-formation/spotify-analytics-on-aws-athena/module/glue_crawler"
    database_name = "spotify_analytics"
    s3_bucket = "spotify-analytics-raw-data"
    crawler_schedule = "cron(0/5 0 1-31 * ? *)"
    crawler_configs = {
        albums_crawler = "transformed_data/albums"
        artists_crawler = "transformed_data/artists"
        songs_crawler = "transformed_data/songs"
    }
# Wait for the data source to be available before proceeding
    #depends_on = [data.aws_s3_bucket.example_bucket]
    
}
