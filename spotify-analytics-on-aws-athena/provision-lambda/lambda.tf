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
    lambda_runtime = "python3.8"
    lambda_memory_size = 128
    source_code_hash = filebase64sha256("/workspaces/terraform/spotify-analytics-on-aws-athena/spotify_extraxt_raw_data.zip")
    client_id_env_var = "ab127ec3521b4297a152d463e88471a7"
    client_secret_env_var = "cd93f807fa85493d908b570eb5841eea"
    lambda_layer_zip_file = "/workspaces/terraform/spotify-analytics-on-aws-athena/spotipy_layer.zip"
    lambda_layer_name = "spotipy_layer"
    lambda_layer_runtime = "python3.8"


}