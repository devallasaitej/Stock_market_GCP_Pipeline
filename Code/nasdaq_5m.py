import yfinance as yf
import pandas as pd
from google.cloud import storage 
from datetime import datetime, timedelta

def download_nasdaq100_data():
    # Set the ticker symbol for NASDAQ-100
    ticker_symbol = "^NDX"

    # Set the time range for data fetching (e.g., from 2021-01-01 to today)
    start_date = datetime.today() - timedelta(days=60)
    end_date = datetime.today()

    # Fetch historical data at 5-minute intervals
    data = yf.download(tickers="^GSPC", period="60d", interval="5m")
    data['Date'] = data.index

    # Reorder the columns with 'Date' as the first column
    data = data[['Date'] + [col for col in data.columns if col != 'Date']]

    # Save the data to a CSV file
    csv_file_path = f"gspc100_data_{start_date.strftime('%Y%m%d')}_{end_date.strftime('%Y%m%d')}.csv"
    data.to_csv(csv_file_path, index=False)

    return csv_file_path

def upload_to_gcs(file_path, bucket_name, destination_folder):
    # Upload the file to Google Cloud Storage
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(f"{destination_folder}/{file_path}")

    blob.upload_from_filename(file_path)

if __name__ == "__main__":
    # Run the download function
    file_path = download_nasdaq100_data()

    # Set your Google Cloud Storage bucket and destination folder
    gcs_bucket_name = 'stocks_capstone'
    gcs_destination_folder = 'nasdaq_gspc_5m'

    # Upload the file to Google Cloud Storage
    upload_to_gcs(file_path, gcs_bucket_name, gcs_destination_folder)

    print(f"Data downloaded and saved to GCS: gs://{gcs_bucket_name}/{gcs_destination_folder}/{file_path}")
