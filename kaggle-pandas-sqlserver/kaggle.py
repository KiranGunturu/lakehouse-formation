import kaggle
import zipfile
import pandas as pd

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

    print(df['Ship Mode'].unique())





