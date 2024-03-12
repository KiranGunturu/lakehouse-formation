# provider configuration
provider "aws" {
    region = "us-east-1"
  
}

# provision lambda function to extract data from spotify Api
module "lambda-raw" {
    source = "/workspaces/terraform/spotify-analytics-on-aws-athena/module/lambda"
    lambda_file_to_be_uploaded = "/workspaces/terraform/spotify-analytics-on-aws-athena/spotify_extraxt_raw_data.zip"
    lambda_function_name = "spotify_extract_raw_data"
    lambda_handler_name = "spotify_analytics_raw.plainText"
    lambda_timeout = 60
    lambda_runtime = "python3.8"
    lambda_memory_size = 512


}