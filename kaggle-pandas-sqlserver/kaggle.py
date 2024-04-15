import kaggle
import zipfile
import pandas as pd
import numpy as np

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

if __name__ == "__main__":

    # unzip
    unzip_csv(zipfilepath)

    # read data from the file and handle null values in the dataset
    df = read_csv(file)
    print(df.head(10))
    print(list(df['Ship Mode'].unique())) # ['Second Class', 'Standard Class', 'Not Available', 'unknown', 'First Class', nan, 'Same Day']

    # replace 'Not Available', 'unknown' with nan
    df.replace(['Not Available', 'unknown'], np.nan, inplace=True)
    print(list(df['Ship Mode'].unique())) # ['Second Class', 'Standard Class', nan, 'First Class', 'Same Day']

    # rename all columns to lowercase and replace the space in the column names with underscore
    df.columns = df.columns.str.lower()
    df.columns = df.columns.str.replace(' ', '_')
    print(df.columns)
    






