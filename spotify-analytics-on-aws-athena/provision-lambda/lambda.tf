# provider configuration
provider "aws" {
    region = "us-east-1"
  
}



# provision lambda function to extract data from spotify Api
module "lambda-raw" {
    source = "/workspaces/terraform/spotify-analytics-on-aws-athena/module/lambda"
    lambda_file_to_be_uploaded = "/workspaces/terraform/spotify-analytics-on-aws-athena/spotify_extraxt_raw_data.zip"
    lambda_function_name = "spotify_extract_raw_data"
    lambda_handler_name = "extract_from_spotify.extract_and_ingest_to_s3"
    lambda_timeout = 60
    lambda_runtime = "python3.9"
    lambda_memory_size = 128
    source_code_hash = filebase64sha256("/workspaces/terraform/spotify-analytics-on-aws-athena/spotify_extraxt_raw_data.zip")
    client_id_env_var = "ab127ec3521b4297a152d463e88471a7"
    client_secret_env_var = "cd93f807fa85493d908b570eb5841eea"
    s3_bucket = "spotify-analytics-raw-data"
    s3_key = "raw_data/landing/"
    lambda_layer_bucket = "resource-provisioning"
    lambda_layer_name_s3key = "layers/dev"
    dependencies_location = "/workspaces/terraform/spotify-analytics-on-aws-athena/module/lambda/lambda_layer"
    


}