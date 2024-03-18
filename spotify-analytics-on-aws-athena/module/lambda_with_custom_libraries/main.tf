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

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy_attachment" "s3_full_access" {
  name       = "s3_full_access"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
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

variable "s3_bucket" {
  description = "name of the s3 bucket where we want lambda to store the data"
  
}

variable "s3_key" {
  description = "name of the s3 folder where we want to lambda to store to the files"
  
}

variable "lambda_layer_name_s3key" {
  description = "s3 folder where our layers zip files will be stored"
  default = null
  
}

variable "lambda_layer_bucket" {
  description = "name of the s3 bucket where we want to store our lambda layer zip files"
  
}

variable "dependencies_location" {
  description = "path where our requirements.txt exists"
  
}

#define variables
locals {
  layer_path        = "lambda_layer"
  layer_zip_name    = "layer.zip"
  layer_name        = "lambda_layer_python_dependencies"
  requirements_name = "requirements.txt"
  requirements_path = "${var.dependencies_location}/${local.requirements_name}"
}


# create zip file from requirements.txt. Triggers only when the file is updated
resource "null_resource" "lambda_layer" {
  triggers = {
    requirements = filesha1(local.requirements_path)
  }
# the command to install python and dependencies to the machine and zips
  provisioner "local-exec" {
    command = <<EOT
      cd ${var.dependencies_location}
      virtualenv -p python3.9 myenv
      source myenv/bin/activate
      which python
      pip install --upgrade pip
      rm -rf python
      mkdir python
      deactivate
      zip -r ${local.layer_zip_name} python/
    EOT
  }
}

# define existing bucket for storing lambda layers
/*resource "aws_s3_bucket" "lambda_layer" {
  bucket_prefix = var.lambda_layer_bucket
}*/

# upload zip file to s3
resource "aws_s3_object" "lambda_layer_zip" {
  bucket     = "${var.lambda_layer_bucket}"
  key        = "${var.lambda_layer_name_s3key}/${local.layer_zip_name}"
  source     = "${var.dependencies_location}/${local.layer_zip_name}"
  depends_on = [null_resource.lambda_layer] # triggered only if the zip file is created
}

# create lambda layer from s3 object
resource "aws_lambda_layer_version" "lambda_layer" {
  s3_bucket           = "${var.lambda_layer_bucket}"
  s3_key              = aws_s3_object.lambda_layer_zip.key
  layer_name          = local.layer_name
  compatible_runtimes = [var.lambda_runtime]
  skip_destroy        = true
  depends_on          = [aws_s3_object.lambda_layer_zip] # triggered only if the zip file is uploaded to the bucket
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = var.lambda_file_to_be_uploaded
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.lambda_handler_name
  timeout = var.lambda_timeout
  runtime = var.lambda_runtime
  memory_size = var.lambda_memory_size
  source_code_hash = var.source_code_hash


  environment {
    variables = {
      client_id = var.client_id_env_var
      client_secret = var.client_secret_env_var
      s3_bucket = var.s3_bucket
      s3_key = var.s3_key
    }
  }

  layers = [aws_lambda_layer_version.lambda_layer.arn]

}

