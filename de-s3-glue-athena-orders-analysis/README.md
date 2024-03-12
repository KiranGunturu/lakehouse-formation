![image](https://github.com/KiranGunturu/terraform/assets/91672788/12dfb6ba-f60a-4c40-a7ce-5613f3cf4863)


### Title: "AWS Data Pipeline: S3 Data Ingestion, Glue Cataloging, Athena Querying, QuickSight Visualization, and Terraform Provisioning"

This project involves the efficient management and utilization of data stored in Amazon S3 (Simple Storage Service) within an AWS (Amazon Web Services) environment. The primary objective is to create a streamlined data pipeline that includes data ingestion, cataloging, querying, and visualization capabilities.

### Key components of the project include:

#### Data Ingestion from S3: 
Utilizing AWS Glue, data ingestion tasks are automated to pull data from S3 buckets. This ensures that new data is seamlessly integrated into the data pipeline, maintaining data currency and relevance.

#### Cataloging with Glue Catalog: 
AWS Glue Catalog serves as the central metadata repository, providing a unified view of the data assets available in the S3 buckets. Glue crawlers are employed to automatically discover the schema of the data and populate the Glue Catalog, enabling easy data discovery and exploration.

#### Data Querying with Athena: 
Amazon Athena is leveraged for ad-hoc querying of the data stored in S3. By using standard SQL queries, users can extract insights and perform data analysis directly on the data cataloged in the Glue Catalog, without the need for traditional data warehousing infrastructure.

#### Data Visualization with QuickSight: 
Amazon QuickSight is employed to create interactive and insightful visualizations based on the data queried from Athena. QuickSight enables users to build dashboards, charts, and graphs to effectively communicate trends, patterns, and insights derived from the data.

#### Infrastructure Provisioning with Terraform: 
Terraform is utilized for infrastructure as code (IaC) to provision and manage all the necessary cloud resources for the data pipeline. This includes setting up AWS Glue resources, Athena databases, S3 buckets, IAM roles, and other components required for data ingestion, cataloging, querying, and visualization.

By integrating these components seamlessly and automating processes wherever possible, the project aims to establish a robust, scalable, and cost-effective data pipeline for efficient data management, analysis, and visualization within an AWS environment.


## Installation

### Terraform installation

##### On Amazon Linux

```sh
sudo yum install -y yum-utils
```
```sh
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```
```sh
sudo yum -y install terraform
```
#### Verify the installation

```sh
terraform --version
terraform -help
```

### AWS CLI installation

```sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
#### Verify the installation

```sh
aws --version
```

#### configure aws credentials: provide access key and secret access key

```sh
aws configure
```
    


### Deployement

```sh
cd de-s3-glue-athena-orders-analysis/
```
#### Initiate the terraform
```sh
terraform init
```
![image](https://github.com/KiranGunturu/terraform/assets/91672788/5aa6e9ca-d581-4353-949a-03fff04a1f20)

#### Plan your actions
```sh
terraform plan
```
![image](https://github.com/KiranGunturu/terraform/assets/91672788/ddbd053d-7bc8-432b-85f1-7aeb2888fd35)

![image](https://github.com/KiranGunturu/terraform/assets/91672788/67d731e6-adb3-4068-a36d-3a80dcf5ada4)


#### Create your aws resources
```sh
terraform apply
```
![image](https://github.com/KiranGunturu/terraform/assets/91672788/49bc8190-2c9a-4250-9d92-2270bbe88948)

![image](https://github.com/KiranGunturu/terraform/assets/91672788/ccb0a9db-0342-48ba-a922-6bb46f58eb48)

![image](https://github.com/KiranGunturu/terraform/assets/91672788/e5ce6c7d-eebd-4cd5-93dc-8ab269c5b4bb)

#### Delete your aws resources
```sh
terraform destroy
```
![image](https://github.com/KiranGunturu/terraform/assets/91672788/9f4dd635-57b5-4b2e-b0fd-a6eb32935798)

