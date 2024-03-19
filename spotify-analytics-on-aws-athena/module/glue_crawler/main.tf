variable "database_name" {
    description = "name of the athena db"
    default = null
  
}


variable "s3_bucket" {
  description = "name of the s3 bucket where we have the data"
  default = null
  
}

# create glue catalog database
resource "aws_glue_catalog_database" "sales_db" {
  name = var.database_name
}


# create an IAM role
# Create an IAM role for Glue and S3
resource "aws_iam_role" "s3_glue_athena_roles" {
  for_each = var.crawler_configs

  name = "${each.key}-GlueAndS3Role"

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


# Attach the Glue service role policy to the IAM role
resource "aws_iam_role_policy_attachment" "glue_service_role_attachment" {
  for_each = aws_iam_role.s3_glue_athena_roles
  role       = each.value.name  # Update this with the actual IAM role name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

data "aws_s3_bucket" "example_bucket" {
  bucket = var.s3_bucket
}

# Create IAM policies for S3 access dynamically based on crawler configurations
resource "aws_iam_policy" "s3_access_policies" {
  for_each = var.crawler_configs

  name        = "S3AccessPolicy-${each.key}"
  description = "Allows access to the specific S3 bucket for ${each.key} crawler."

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutBucket"
      ],
      "Resource": [
        "${data.aws_s3_bucket.example_bucket.arn}/${var.crawler_configs[each.key]}/*"

      ]
    }]
  })
}



# attach the s3 policy to the IAM role created above
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  for_each = aws_iam_role.s3_glue_athena_roles
  role       = each.value.name
  policy_arn = aws_iam_policy.s3_access_policies[each.key].arn
}

variable "crawler_configs" {
  description = "Map of crawler names and corresponding S3 folder locations"
  type        = map
  default     = {
    
    # Add more crawlers and their corresponding folder locations as needed
  }
}

# Create glue crawlers dynamically based on the provided configurations
resource "aws_glue_crawler" "crawlers" {
  for_each      = var.crawler_configs
  database_name = aws_glue_catalog_database.sales_db.name
  name          = each.key
  role          = aws_iam_role.s3_glue_athena_roles[each.key].arn

  s3_target {
    #path = "s3://${data.aws_s3_bucket.example_bucket.arn}/${each.value}/"
    path = "s3://${var.s3_bucket}/${each.value}/"
  }


  recrawl_policy {
    recrawl_behavior = "CRAWL_NEW_FOLDERS_ONLY"
  }

  schema_change_policy {
    update_behavior = "LOG"
    delete_behavior = "LOG"
  }

  configuration = jsonencode({
    "Version"    = 1.0,
    "Grouping"   = {
      "TableGroupingPolicy" = "CombineCompatibleSchemas"
    }
  })
}


resource "aws_glue_trigger" "crawler_trigger" {
  for_each        = aws_glue_crawler.crawlers
  name            = "${each.key}-trigger"
  type            = "SCHEDULED"
  schedule        = "cron(0 8 * * ? *)"  # Example schedule: daily at 8:00 AM UTC
  enabled         = true
  start_on_creation = true

  actions {
    job_name = aws_glue_crawler.crawlers[each.key].name
    # Additional actions if needed
  }
}