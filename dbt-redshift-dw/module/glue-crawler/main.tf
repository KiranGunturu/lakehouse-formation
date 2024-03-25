# define aws provider
provider "aws" {
    region = "us-east-1"
  
}

# declare variable for glue catalog db
variable "aws_glue_catalog_database" {
    description = "name of the glue catalog database"
    type = string
  
}

variable "s3_bucket" {
    description = "name of the s3 bucket on which we want the glue crawler ro run"
  
}

variable "aws_glue_crawler_name" {
    description = "name of the glue crawler"
    type = string
    default = "my_crawler"
  
}
variable "table_prefix" {
    description = "name of the table_prefix"
  
}

variable "csv_classifier_name" {
    description = "name of the CSV classifier"
    default = "my_classifier"
  
}
# create glue catalog database
resource "aws_glue_catalog_database" "my_db" {
  name = var.aws_glue_catalog_database
}

# create an IAM role
resource "aws_iam_role" "s3-glue-athena-redshift" {
  name = "s3-glue-athena-redshift"
  
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
  role       = aws_iam_role.s3-glue-athena-redshift.name
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
        "${data.aws_s3_bucket.example_bucket.arn}"
      ]
    }]
  })
}

# attach the s3 policy to the IAM role created above
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.s3-glue-athena-redshift.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

data "aws_s3_bucket" "example_bucket" {
  bucket = var.s3_bucket
}

resource "aws_glue_classifier" "csv_classifier" {
  name = var.csv_classifier_name

  csv_classifier {
    allow_single_column    = true
    contains_header        = "PRESENT"
    delimiter              = "|"
    disable_value_trimming = false
    quote_symbol   = "\u0022"
  }
}

# create glue crawler
resource "aws_glue_crawler" "sales_crawler_test" {
  database_name = aws_glue_catalog_database.my_db.name
  name          = var.aws_glue_crawler_name
  role          = aws_iam_role.s3-glue-athena-redshift.arn
  table_prefix = var.table_prefix
  classifiers        = [aws_glue_classifier.csv_classifier.name]

  s3_target {
    path = "s3://${var.s3_bucket}"
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
