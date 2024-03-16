terraform {
  backend "s3" {
    bucket = "resource-provisioning"
    region = "us-east-1"
    key = "s3/terraform.tfstate"

  }
  }

/*variable "s3_bucket_for_tfstate" {
    description = "name of the s3 bucket folder where we want to store the tfstate file"
  
}

variable "s3_folder_for_tfstate" {
    description = "s3 folder where we want to store the tfstate file"
  
}

variable "region_s3_for_tfstate" {
    description = "region of the s3 bucket where we want to store the tfstate file"
    default = "us-east-1"
  
}
terraform {
  backend "s3" {
    bucket = var.s3_bucket_for_tfstate
    region = var.region_s3_for_tfstate
    key = var.s3_folder_for_tfstate

    
  }
}*/