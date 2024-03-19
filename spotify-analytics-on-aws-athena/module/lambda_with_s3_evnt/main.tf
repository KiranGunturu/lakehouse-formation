provider "aws" {
    region = "us-east-1"
  
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda_transform" {
  name               = "iam_for_lambda_transform"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy_attachment" "s3_full_access" {
  name       = "s3_full_access"
  roles      = [aws_iam_role.iam_for_lambda_transform.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "addLambdarole" {
  name       = "addLambdarole"
  roles      = [aws_iam_role.iam_for_lambda_transform.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

variable "lambda_function_name" {
    description = "name of the lambda funciton"
    default = null
  
}

variable "lambda_handler_name" {
    description = "name of the lambda function handler"
    default = null
  
}

variable "lambda_timeout" {
    description = "value of the lambda timeout in secs"
    default = 3
  
}

variable "lambda_file_to_be_uploaded" {
    description = "name of the zip file to be uploaded"
    default = "test.zip"
  
}

variable "lambda_runtime" {
    description = "value of the lambda runtime"
    default = "python3.2"
  
}

variable "lambda_memory_size" {
    description = "size of the memory required for lambda function"
    default = 128
  
}

variable "client_id_env_var" {
    description = "value of the spotify client id"
    default = null

  
}

variable "client_secret_env_var" {
    description = "value of the spotify client id"
    default = null

}

variable "source_code_hash" {
    description = "value of the source_code_hash to address code change and deployment"
  
}

variable "lambda_spotipy_layer_zip_file" {
    description = "file name of the lambda layer that we want to create the layer as"
    default = null
  
}

variable "lambda_spotipy_layer_name" {
    description = "name of the lambda layer name"
    default = null
  
}

variable "lambda_layer_runtime" {
    description = "value of the lambda layer runtime"
    default = null
  
}

variable "s3_bucket" {
  description = "name of the s3 bucket where we want lambda to store the data"
  
}

variable "s3_landing" {
  description = "name of the s3 folder where we want to lambda to store to the files"
  
}

variable "s3_archive" {
  description = "name of the s3 folder where we want to lambda keep the archive files"
  
}

variable "layer" {
  description = "name of the aws provided pandas layer"
  default = null
  
}

variable "layer_version" {
  description = "name of the aws provided pandas layer"
  default = null
  
}

variable "s3_evnt_bucket_arn" {
  description = "name of the bucket on which lambda to be triggred based on the event in s3"
  default = null
  
}

variable "s3_evnt_bucket_prefix" {
  description = "name of the s3 folder on which lambda to be triggred based on the event in s3"
  default = null
  
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

/*resource "aws_lambda_layer_version" "layer" {
  layer_name = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:layer:${var.layer}:${var.layer_version}"
  #compatible_runtimes = [var.lambda_layer_runtime]
}*/



resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = var.lambda_file_to_be_uploaded
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda_transform.arn
  handler       = var.lambda_handler_name
  timeout = var.lambda_timeout
  runtime = var.lambda_runtime
  memory_size = var.lambda_memory_size
  source_code_hash = var.source_code_hash


  environment {
    variables = {
      s3_bucket = var.s3_bucket
      s3_landing = var.s3_landing
      s3_archive = var.s3_archive
    }
  }

  
  #layers = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:layer:${var.layer}:${var.layer_version}"]
  #layers = [aws_lambda_layer_version.layer.arn]
}


data "aws_s3_bucket" "example_bucket" {
  bucket = var.s3_evnt_bucket_arn
}

resource "aws_lambda_permission" "example_lambda_permission" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "s3.amazonaws.com"

  source_arn = data.aws_s3_bucket.example_bucket.arn
}



resource "aws_s3_bucket_notification" "example_bucket_notification" {
  bucket = var.s3_evnt_bucket_arn

  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.s3_evnt_bucket_prefix  # Specify the folder path to watch for object creation
  }
}
