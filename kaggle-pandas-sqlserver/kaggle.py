import kaggle
import zipfile
import pandas as pd
import numpy as np
import sqlalchemy as sal
import boto3
from io import StringIO
#from kaggle.api.kaggle_api_extended import KaggleApi

#!kaggle datasets download kirangunturu01/retail-orders -f orders.csv

# constants
zipfilepath = "/workspaces/lakehouse-formation/kaggle-pandas-sqlserver/retail_orders.zip"
file = "/workspaces/lakehouse-formation/kaggle-pandas-sqlserver/orders.csv"
bucket_name="kaggle-retail-orders"

def download_from_kaggle():
    # Instantiate the Kaggle API
    api = KaggleApi()

    # Authenticate with your Kaggle credentials
    api.authenticate()

    # Specify the dataset you want to download
    dataset_name = 'kirangunturu01/retail-orders'  # Replace with the actual username and dataset name

    # Download the dataset
    api.dataset_download_files(dataset_name)


# unzip the file to the local directory
def unzip_csv(zipfilepath):
    unzip = zipfile.ZipFile(zipfilepath)
    unzip.extractall()
    unzip.close()

# read csv and create DataFrame
def read_csv(file):
    df = pd.read_csv(file)
    return df

def ingest_to_sqlserver(df):
    # create the sql server connection
    engine = sal.create_engine('mssql://KGUNTURU/SQLEXPRESS/master?driver=ODBC+DRIVER+17+FOR+SQL+SERVER')
    conn = engine.connect()

    # load the data to sql server with replace the table if exists. drop and create the table
    #df.to_sql('orders', con=conn, index=False, if_exists = 'replace') # cons: pandas will create highest possible datatype like varchar(max)


    # load the data to sql server with append option. table should exist first
    df.to_sql('orders', con=conn, index=False, if_exists = 'append')

def data_cleaning(df):
    print(df.head(10))
    print(list(df['Ship Mode'].unique())) # ['Second Class', 'Standard Class', 'Not Available', 'unknown', 'First Class', nan, 'Same Day']

    # replace 'Not Available', 'unknown' with nan
    df.replace(['Not Available', 'unknown'], np.nan, inplace=True)
    print(list(df['Ship Mode'].unique())) # ['Second Class', 'Standard Class', nan, 'First Class', 'Same Day']

    # rename all columns to lowercase and replace the space in the column names with underscore
    df.columns = df.columns.str.lower()
    df.columns = df.columns.str.replace(' ', '_')
    print(df.columns)
    print(df.head(3))

    # create discount column, sale price and profit columns
    df['discount'] = df['cost_price']*df['discount_percent']*.01
    df['sale_price'] = df['list_price']-df['discount']
    df['profit'] = df['sale_price']-df['cost_price']
    print(df.head(3))
    print(df.dtypes)

    # convert order date from object datatype to datetime
    df['order_date'] = pd.to_datetime(df['order_date'], format="%Y-%m-%d")
    print(df.dtypes)

    # drop cost_price, list_price and discount_percent columns
    df.drop(columns=['cost_price', 'list_price','discount_percent'], inplace=True)
    print(df.head(3))
    return df

def push_to_s3(df):
    csv_buffer = StringIO()
    df.to_csv(csv_buffer, index=False)
    s3_client = boto3.resource('s3')
    s3_client.Object(bucket_name, 'orders_data.csv').put(Body=csv_buffer.getvalue())





if __name__ == "__main__":

    # download the dataset from kaggle
    #download_from_kaggle()

    # unzip
    unzip_csv(zipfilepath)

    # read data from the file and handle null values in the dataset
    df = read_csv(file)

    # data cleaning
    df =  data_cleaning(df)

    # load to s3
    push_to_s3(df)




    

    



    
    






