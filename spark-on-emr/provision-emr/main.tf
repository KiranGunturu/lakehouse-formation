resource "aws_iam_role" "emr_service_role" {
  name = "emr_service_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticmapreduce.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"]
}

# Generate an SSH key pair using the TLS provider
resource "tls_private_key" "my_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an EC2 key pair using the public key from the generated private key
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"  # Name of the key pair
  public_key = tls_private_key.my_key_pair.public_key_openssh  # Use the public key from TLS provider
}


# Define an IAM policy for S3 access to an existing bucket
resource "aws_iam_policy" "emr_s3_access_policy" {
  name        = "emr-s3-access-policy"
  description = "Policy that allows EMR to access a specific existing S3 bucket"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::spark-emr-data-processing",
          "arn:aws:s3:::spark-emr-data-processing/*"
        ]
      }
    ]
  })
}



# Define the EC2 instance profile
resource "aws_iam_role" "emr_ec2_instance_role" {
  name = "emr_ec2_instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "emr_ec2_instance_role_policy_attachment" {
  role       = aws_iam_role.emr_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticMapReduceFullAccess"
}

resource "aws_iam_instance_profile" "emr_instance_profile" {
  name = "emr_instance_profile"
  role = aws_iam_role.emr_ec2_instance_role.name
}

resource "aws_emr_cluster" "spark-emr-cluster" {
  name           = "spark-emr-cluster"
  release_label  = "emr-6.14.0"
  applications   = ["Spark", "Hadoop", "Hue", "Tez", "JupyterHub", "JupyterEnterpriseGateway", "Hive"]
  service_role   = aws_iam_role.emr_service_role.arn

 ec2_attributes {
    instance_profile = aws_iam_instance_profile.emr_instance_profile.name
    #key_name          = aws_key_pair.my_key_pair.key_name  # Attach the key pair here
    key_name          = "spark-emr-key" # alreeady existing key pair
  }

  master_instance_group {
    instance_type = "m5.xlarge"
  }

  core_instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 1
  }
}