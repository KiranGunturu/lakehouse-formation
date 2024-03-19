# provider configuration
provider "aws" {
    region = "us-east-1"
  
}



# provision athena db and glue crawler , assign proper permission to IAM role.
module "lambda-raw" {
    source = "/workspaces/terraform/spotify-analytics-on-aws-athena/module/glue_crawler"
    database_name = "spotify_analytics"
    s3_bucket = "spotify-analytics-raw-data"
    crawler_configs = {
        albums_crawler = "transformed_data/albums/"
        artists_crawler = "transformed_data/artists/"
        songs_crawler = "transformed_data/songs/"
    }

    
}
