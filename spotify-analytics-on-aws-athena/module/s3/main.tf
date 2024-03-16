# define aws provider
provider "aws" {
    region = "us-east-1"
  
}

variable "bucket" {
    description = "name of the s3 bucket"
    type = string
    default = null
  
}

variable "Environment" {
    description = "stage of the s3 bucket for cost tagging use cases"
    type = string
    default = null
  
}

variable "objects" {
  type = list(string)
  default = []
}

# create s3 bucket, folder, block public access and disable the versioning
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket
  tags = {
    Name        = var.bucket
    Environment = var.Environment
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}


resource "aws_s3_object" "s3_bucket_objects" {
  for_each = { for obj in var.objects : obj => null } #convert the list into a dict where each key is an object key (folder path) and the value is null

  bucket = aws_s3_bucket.s3_bucket.id
  key    = each.key
}




