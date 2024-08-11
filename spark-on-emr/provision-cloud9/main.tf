provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

# Create an EC2 instance to use with Cloud9
resource "aws_instance" "cloud9_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a suitable Amazon Linux 2 AMI ID
  instance_type = "t3.micro"  # Choose an instance type that suits your needs

  tags = {
    Name = "cloud9-instance"
  }
}

# Create the Cloud9 environment
resource "aws_cloud9_environment_ec2" "my_cloud9" {
  name = "my-cloud9-environment"
  instance_type = "t3.micro"  # Should match the instance type you use in aws_instance

  # Optional: specify the SSH key pair for the environment
  # key_name = "my-key-pair"  # Uncomment if you want to use an SSH key pair

  # Optional: specify the subnet ID for the environment
  # subnet_id = "subnet-xxxxxxxx"  # Uncomment and replace with your subnet ID

  tags = {
    Name = "my-cloud9-environment"
  }
}
