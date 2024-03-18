# provider configuration
provider "aws" {
    region = "us-east-1"
  
}



# provision lambda function to extract data from spotify Api
module "lambda-raw" {
    source = "/workspaces/terraform/spotify-analytics-on-aws-athena/module/lambda_with_cloudwatch_evnt"
    lambda_file_to_be_uploaded = "/workspaces/terraform/spotify-analytics-on-aws-athena/spotify_extraxt_raw_data.zip"
    lambda_function_name = "spotify_extract_raw_data"
    lambda_handler_name = "extract_from_spotify.extract_and_ingest_to_s3"
    lambda_timeout = 300
    lambda_runtime = "python3.8"
    lambda_memory_size = 128
    source_code_hash = filebase64sha256("/workspaces/terraform/spotify-analytics-on-aws-athena/spotify_extraxt_raw_data.zip")
    client_id_env_var = "ab127ec3521b4297a152d463e88471a7"
    client_secret_env_var = "cd93f807fa85493d908b570eb5841eea"
    lambda_spotipy_layer_zip_file = "/workspaces/terraform/spotify-analytics-on-aws-athena/spotipy_layer.zip"
    lambda_spotipy_layer_name = "spotipy_layer"
    lambda_layer_runtime = "python3.8"
    #pandas_layer = "AWSSDKPandas-Python38"
    s3_bucket = "spotify-analytics-raw-data"
    s3_key = "raw_data/landing/"
    
}


# provision lambda function to extract data from spotify Api
module "lambda-transform" {
    source = "/workspaces/terraform/spotify-analytics-on-aws-athena/module/lambda_with_s3_evnt"
    lambda_file_to_be_uploaded = "/workspaces/terraform/spotify-analytics-on-aws-athena/transform_spotify_data_s3.zip"
    lambda_function_name = "spotify_transform_raw_data"
    lambda_handler_name = "transform_spotify_data_s3.transform_spotify_data_to_s3"
    lambda_timeout = 300
    lambda_runtime = "python3.8"
    lambda_memory_size = 128
    source_code_hash = filebase64sha256("/workspaces/terraform/spotify-analytics-on-aws-athena/transform_spotify_data_s3.zip")
    lambda_spotipy_layer_zip_file = "/workspaces/terraform/spotify-analytics-on-aws-athena/spotipy_layer.zip"
    s3_bucket = "spotify-analytics-raw-data"
    s3_landing = "raw_data/landing/"
    s3_archive = "raw_data/archive/"
    
}