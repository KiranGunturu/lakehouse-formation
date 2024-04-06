### Title: "Automated Data Pipeline for Spotify: Extracting, Transforming, and Analyzing Music Data Using AWS Lambda, S3, Glue, and Athena"

The project aims to develop an end-to-end data pipeline for extracting, transforming, and analyzing data from the Spotify API. Leveraging AWS services such as Lambda, S3, Glue, Athena, and Terraform, the pipeline automates the extraction of data, transformation into structured formats, and enables analytical queries for insights.

### Prerequisites

* AWS Account
* Understating of AWS services
* Data Strategy and Planning
* Security and Compliance
* Performance and Cost management
* Technical Skills
* Backup and Recovery
* Documentation and Support


### Steps Involved in Designing DW

* Define Business Use Case 
* Identify the Grain
* Design Dimensions tables
* Design Fact tables
* Develop ETL process
* Implement Slowly Changing Dimensions
* Testing and Validation
* Documentation and Training

### 1. Define Business Use Case

* Understand Business Processes: Start by identifying and understanding the key business processes that the data warehouse will Support
* Gather Requirements: Work with stakeholders to gather detailed requirements for each business process

### 2. Identify the Grain

* Define the Grain: The grain of the data warehouse defines the most detailed level at which data is captured in a fact table. For each business process or subject area, we need to percisely define the grain.
* consistency: Ensure that the grain is consistently defined across the data warehouse to avoid confusion and ensure accurate reporting.

### 3. Design Fact Tables

* Identify Facts: Facts are the measurements or metrics that business users want to analyze. Based on the business requirements and the grain defintion, identify the facts that will be stored in each fact table.
* Design Fact Table Structure: Create a table structure that included keys to link to each of the related dimention tables, as well as the numeric fact columns (ex: sale amount, units sold, discount). Fact tables often also include degenetate dimensions, which are dimensions that are derived from the fact itself, such as transaction ID.

### 4. Design Dimension Tables

* Identify dimensions: Dimensions are descriptive attributes related to fact data. They provide context for the facts. For each fact table, Identify the dimensions that will be linked to it.
* Table Design: For each dimension, design a corresponding dimensions table. This table should include a unique key and a set of attributes that describe the dimensions.
* Consider Hierarchies: Many dimensions have natural Hierarchies (ex: date - year - quarter - month - day) that should be modeled in the dimensions table to support drill-down analysis.

### 5. Develop ETL Process

* ETL: Design and Implement ETL process to populate the dimensions and fact tables. This involved extracting data from source systems. transforming it to fit the data warehouse schema, and loading it into the data warehouse.
* Data Quality and cleansing: As part of the ETL process, implement steps to ensure data quality and perform data cleaning to correct any issues in the source data.

### 6. Implement SCD 

* Manage Dimension Changes: Dimensions can change over time (ex: change in product price, customer relocates, phone number change)

### 7. Testing and Validation

* Test for Accuracy: Before going live, thoroughly test the data warehouse to ensure that is accurately reflects the source data and meets the business requirements.
* Validation with Business Users: work with business users to validate that the reports and queries they run against the data warehouse produce expected results and support their decision-making process.

### 8. Documentation and Training

* Document the Design: Document the data warehouse design, including the schema, ETL processes, and any business rules applied. This documentation is crucial for maintenance and future development.
* Train End Users: Provide training to end users on how to use the data warehouse and BI tools effectively to extract insights and make data-driven decisions.

# Components:

### AWS Redshift:

* Acts as the core data warehousing platform, providing a highly scalable and performant environment for storing and analyzing data.
* Utilizes Redshift's MPP (Massively Parallel Processing) architecture for distributed query execution, enabling rapid data retrieval and analysis.

### S3 (Simple Storage Service):

* Serves as the primary data lake for storing raw data in its native format.
* Data from various sources is ingested into S3 buckets, maintaining the flexibility of schema-on-read for future transformations.

### AWS Glue:

* Glue Catalog acts as the central metadata repository, storing table definitions, schema information, and partitioning details.
* Glue Crawlers automatically discover and catalog metadata from various data sources, ensuring consistency and accuracy in data representation.
* Glue Classifiers identify the format and schema of ingested data, facilitating seamless integration with downstream processes.

### Medalian Architecture:

### Bronze Layer: 
* Raw, unprocessed data resides in the Bronze layer within S3 buckets. This layer retains data in its original form, allowing for easy rollback and reprocessing if needed.
### Silver Layer: 
* Processed and cleansed data is staged in the Silver layer, representing a refined version of the raw data. Transformations such as data cleansing, normalization, and type casting are performed in this layer.

### Gold Layer: 
* The Gold layer hosts curated, business-ready data that has undergone extensive transformation, enrichment, and aggregation. This layer serves as the foundation for analytical queries and reporting, providing valuable insights to stakeholders.

### dbt (data build tool):

* dbt is used for orchestrating data transformations and building data models within the Redshift environment.
* It leverages SQL-based transformations to create and manage data pipelines, ensuring data consistency and reliability across different layers of the data warehouse.
* dbt models are version-controlled and tested, promoting collaboration and maintaining code quality throughout the development lifecycle.

# Workflow:

### Data Ingestion:

* Raw data is ingested from various sources into S3 buckets, maintaining the original format and structure.
* Glue Crawlers automatically discover and catalog metadata, populating the Glue Catalog with table definitions.

### Data Transformation:

* dbt pipelines are triggered to perform transformations on the raw data stored in the Bronze layer.
* Data quality checks and validation are conducted to ensure accuracy and consistency in the transformed data.
* Transformed data is staged in the Silver layer, ready for further refinement.

### Data Enrichment:

* Additional data enrichment and aggregation processes are applied to the Silver layer data, preparing it for consumption by business users.
* Complex business logic and calculations are implemented to derive actionable insights from the data.

### Data Consumption:

* Curated data from the Gold layer is made available to end-users for analytical queries, reporting, and decision-making.
* Business intelligence tools and dashboards connect to Redshift to access the structured data models generated by dbt.

### Benefits:

### Scalability: 
AWS services such as Redshift and S3 provide elastic scalability, allowing the data warehouse to handle growing volumes of data.

### Flexibility: 
The Medalian architecture allows for iterative development and refinement of data models, accommodating changing business requirements.

### Reliability: 
Automated data pipelines and version-controlled transformations ensure data consistency and reliability throughout the warehouse.

### Performance: 
Redshift's MPP architecture and optimized data models generated by dbt enable fast query performance, supporting real-time analytics and reporting.
By implementing this data warehouse solution on AWS with dbt and the Medalian architecture, the organization can achieve a scalable, flexible, and reliable platform for deriving valuable insights from its data assets.



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
    


# Deployement - Provision S3 bucket with Multiple Keys
#### Lets verify if we already have the bucket that we want to provision

```sh
aws s3api list-buckets --query 'Buckets[*].[Name]' --output text | grep "dbt"
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/77465eab-49f5-4c69-9990-da61a5d15937)

#### Initiate the terraform
```sh
terraform init
```
#### Plan your actions
```sh
terraform plan
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/2c2c77df-d975-4980-af1e-dba355dcdd84)

#### Create your S3 bucket by passing input args to the custom s3 terraform module
```sh
terraform apply
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/41761647-46ca-4164-8539-38b2cdd3275d)

#### Verify
```sh
aws s3api list-buckets --query 'Buckets[*].[Name]' --output text | grep "dbt"
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/a2469981-82a0-4843-a641-370f838484df)

```sh
aws s3 ls s3://dbt-redshift-dw/ --recursive --summarize
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/f1af1cd9-76ce-4ade-b92c-9703928072df)

# Generate CSV files (Source Data) - Dimension and Fact Table Data with Faker Module

```sh
cd /workspaces/lakehouse-formation/dbt-redshift-dw
pipenv install -r requirements.txt
pipenv shell
cd /data
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/48f70f3e-6090-4652-bea6-565fe3ef68eb)

```sh
python main.py
```
```sh
ls
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/ef43a482-6260-4f84-b334-75ababe32ec0)

# Upload these files to S3

```sh
aws s3 ls s3://dbt-redshift-dw/ --recursive --summarize
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/e0efb054-ef45-47b3-a6a2-23783496b2b4)

# Provision Glue Catalog Database, CSV Classifier, Glue Crawler, and Glue Trigger to Run Crawler
### Verify if we have any of them exits so we don't try to create with the same name.

```sh
aws glue list-crawlers
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/e6db4ef1-01fa-47d0-8dcd-4983bb76e2b6)

```sh
aws glue list-triggers
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/c1dc5000-ef03-46a4-a6b4-bcc49ed92682)

```sh
aws glue get-databases
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/c99792c0-64fd-4954-b1f2-5e8f3fe2fd7b)

```sh
aws glue get-tables --database-name your-database-name
```
### Resource Provisioning
```sh
cd provision-gluecrawler-classifier-catalogdb
terraform apply
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/7af592ee-b1b0-4ebc-bcda-0127f57527c8)


![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/d5124d04-5b2f-4b38-b35f-27ceeda5247d)


![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/9102f7a7-bff6-42d7-9b25-af342ab15196)


![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/8d4b1e8e-da03-4580-943a-71b0c50c6ac5)

# Run the Crawler to Create Tables.

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/27f4ff37-c7fa-4ca1-8331-3ff3df78e4ab)


![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/b027df97-17b6-4800-ae70-e7672c996733)


# Provision VPC, Private and Public subnets, Route tables, S3 endpoint and Internet Gateway.
```sh
cd /workspaces/lakehouse-formation/dbt-redshift-dw/provision-vpc
terraform apply
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/535ca77c-f116-4e22-ae9d-19c50f5e734d)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/9b2822ff-a8db-47f8-b560-aff1bed8df67)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/d89d074e-7c27-41a0-a3a5-2faae9b83834)

# Provision Redshift Cluster Subnet Group
```sh
cd /workspaces/lakehouse-formation/dbt-redshift-dw/provision-redshift-cluster-subnet-group
terraform apply
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/c4a8898a-844e-404d-9d33-dc60f261428d)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/6b2f59c6-f97a-4f50-9332-2fc013b85b6e)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/27237c83-0a9a-4927-8a0c-a293fe93a352)


# Provision Redshift Cluster
```sh
cd /workspaces/lakehouse-formation/dbt-redshift-dw/provision-redshift-cluster-subnet-group
terraform apply
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/00b5633f-e991-4016-b234-e900cf972453)
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/467f2cd9-ea14-4325-b7ca-8d2fa4790abd)

### Add an inbound rule to the VPC security group to allow communication to Redshift from where we are connecting. Ex: MYip

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/f5080e7a-b4b7-41ca-a536-fdc13381da5e)

### Associate private subnet to the igw.

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/9a04ff07-deeb-4c87-a796-c5acf9a52302)

# Connect to Redshift using DBeaver.

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/a042ab7b-5f4a-49dc-a77c-d5efe80dbe0e)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/770b5911-50cf-48db-ab48-114584ddedb3)













