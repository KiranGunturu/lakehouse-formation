# declare variable for s3 fodler
variable "s3_folder_path" {
    description = "path to the s3 fodler"
    type = string
  
}

# define aws provider
provider "aws" {
    region = "us-east-1"
  
}

# create s3 bucket, folder, block public access and disable the versioning
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "engineering-sales"
  tags = {
    Name        = "data-engineering-sales"
    Environment = "Dev"
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

resource "aws_s3_object" "s3_folder" {
    key    = "orders/"
    bucket = aws_s3_bucket.s3_bucket.id

}

# create glue catalog database
resource "aws_glue_catalog_database" "sales_db" {
  name = "sales_db"
}

# create an IAM role
resource "aws_iam_role" "s3-glue-athena" {
  name = "GlueAndS3Role"
  
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
}

# attach the Glue service role to the IAM role created above
resource "aws_iam_role_policy_attachment" "glue_service_role_attachment" {
  role       = aws_iam_role.s3-glue-athena.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# create policy to access to s3 bucket and folders
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Allows access to the specific S3 bucket."

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.s3_bucket.arn}/${var.s3_folder_path}/*"
      ]
    }]
  })
}

# attach the s3 policy to the IAM role created above
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.s3-glue-athena.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# create glue crawler
resource "aws_glue_crawler" "sales_crawler_test" {
  database_name = aws_glue_catalog_database.sales_db.name
  name          = "sales_crawler"
  role          = aws_iam_role.s3-glue-athena.arn

  s3_target {
    path = "s3://${aws_s3_bucket.s3_bucket.id}/${var.s3_folder_path}/"
  }


   recrawl_policy { 
     recrawl_behavior = "CRAWL_NEW_FOLDERS_ONLY"
   }

  configuration = <<EOF
{
  "Version":1.0,
  "Grouping": {
    "TableGroupingPolicy": "CombineCompatibleSchemas"
  }
}
EOF
}