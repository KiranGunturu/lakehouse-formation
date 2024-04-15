import kaggle
import zipfile36=0.1.3
import pandas as pd
import numpy as np
import sqlalchemy as sal
import boto3
from io import StringIO

#!kaggle datasets download kirangunturu01/retail-orders -f orders.csv

# constants
zipfilepath = "/workspaces/lakehouse-formation/kaggle-pandas-sqlserver/retail_orders.zip"
file = "/workspaces/lakehouse-formation/kaggle-pandas-sqlserver/orders.csv"

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





if __name__ == "__main__":

    # unzip
    unzip_csv(zipfilepath)

    # read data from the file and handle null values in the dataset
    df = read_csv(file)

    # data cleaning
    df =  data_cleaning(df)


    

    



    
    






