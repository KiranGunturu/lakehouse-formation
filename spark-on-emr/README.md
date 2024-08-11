
# AWS Data Analytics Project

Overview
This project demonstrates the end-to-end process of setting up and running a data analytics pipeline on AWS. The pipeline leverages a combination of AWS services including EMR, S3, Terraform, Step Functions, and IAM. The project automates the provisioning of resources, the execution of Spark jobs, and manages permissions, all within a scalable and secure environment.

Project Components

### 1. Infrastructure Setup with Terraform
### EMR Cluster Provisioning: 
Terraform scripts are used to provision an EMR cluster, which is configured to process large-scale data efficiently.
### S3 Buckets: 
S3 is used as the primary storage solution for input and output data.
### EC2 Key Pairs: 
Created using Terraform for secure SSH access to EMR nodes.
### IAM Permissions: 
Managed through Terraform to ensure secure access to resources.
### 2. AWS CLI & Terraform Installation
Instructions are provided for installing AWS CLI and Terraform, enabling users to interact with AWS services from their local machines or CI/CD pipelines.
### 3. Spark Code Development
Spark Jobs: Spark code is written to perform data transformations and analytics. The code reads input data from S3, processes it, and writes the output back to S3.
Step Functions: The Spark job is executed as a step job on the EMR cluster using Step Functions, ensuring smooth orchestration of tasks.
### 4. GitHub Codespaces Integration
For developers without access to a personal laptop, GitHub Codespaces is utilized. This provides a cloud-based development environment pre-configured with the necessary tools and configurations.
### 5. Data Processing Workflow
Reading from S3: Input data is fetched from an S3 bucket. \n

Writing to S3: Processed data is written back to a designated S3 bucket.
Prerequisites
### AWS Account: 
Access to an AWS account with permissions to create and manage EMR, S3, IAM, and other related resources.
### AWS CLI: 
Installed on your local machine for interaction with AWS services.
### Terraform: 
Installed for infrastructure automation.
### GitHub Account: 
Access to GitHub Codespaces if needed.


# Installation

### Install aws cli on linux machine

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
#### Verify

```bash
aws --version
```
![image](https://github.com/user-attachments/assets/fad27b5d-c850-4ed2-8736-2e1c5f757cb2)

### configure aws creds using either aws account root user and an IAM user
```bash
aws configure
```
![image](https://github.com/user-attachments/assets/a17763f7-69eb-4498-b266-907d5904508f)

### Install Terraform

find out the distribution

```bash
cat /etc/*-release
```
![image](https://github.com/user-attachments/assets/e00ca1a4-2d99-4a51-9fbd-f15ca91b8ec4)

below is for linux distribution

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

```
```bash
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

```

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

```

```bash
sudo apt update
```
```bash
sudo apt-get install terraform
```
#### Verify

```bash
terraform -version
```
![image](https://github.com/user-attachments/assets/e21eb583-17e3-47b8-b3b2-40e62ea4107c)


If you don’t have a personal Linux machine or are hesitant to install something on your office machine, don’t worry. We have something called GitHub Codespaces. GitHub will provide us with a virtual machine that comes with 2 CPUs and 4 GB of RAM, and we can practice on it for up to 60 hours per month. That means we can practice for approximately 2 hours per day.

    To set up your environment in GitHub Codespaces:

    1) Log in to your GitHub repository.

    2) Click on Code.
    
    3)  Click on Codespaces on the main page. This will open up a virtual machine.

    4) In the search box, type the following:

        1)  > Add Dev Container Config Files:

        Click on Add Dev container config files (or choose from the drop-down menu).
        Click on Modify your active configuration.
        Search for Terraform.
        Choose the option with the verified mark at the end.

        2) Install AWS CLI:

        Repeat the same steps as above to install the AWS CLI.

        3) Rebuild Container:

        > rebuild - Click on Rebuild container to apply the changes.



# Provisioning s3

### S3
```bash
/workspaces/lakehouse-formation/spark-on-emr/provision-s3
```
![image](https://github.com/user-attachments/assets/d62aaec3-f24c-4d29-9b72-64a6fcd1b36a)

below is the reusable module for s3. customize your object names and name of the bucket.

![image](https://github.com/user-attachments/assets/87884761-e1a3-4bb6-aca9-24fb30bd6d79)

I do not have the bucket mentioned above in my aws account.

```bash
aws s3api list-buckets --query "Buckets[?starts_with(Name, 'spark')].Name" --output text
```
![image](https://github.com/user-attachments/assets/123663dd-6ddc-4142-851c-f4bb89452111)

```bash
terraform init
```
![image](https://github.com/user-attachments/assets/096b99af-464c-4fb5-aeca-a7b649ba53eb)

```bash
terraform plan
```
![image](https://github.com/user-attachments/assets/0e342a19-6f9a-4df8-a2e0-0bb9eb5cc933)

![image](https://github.com/user-attachments/assets/7e616376-3169-4279-bbb3-b9fc1b7a0bcb)


```bash
terraform apply
```
![image](https://github.com/user-attachments/assets/5e1c92a1-9f5b-4031-b1a8-a31948550642)

### verify if s3 is provisioned properly

```bash
aws s3api list-buckets --query "Buckets[?starts_with(Name, 'spark')].Name" --output text
```
![image](https://github.com/user-attachments/assets/bc382089-e4de-41a4-98af-e12b81291a62)

# Provisioning EMR









