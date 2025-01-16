# How to get list of all SKU-IDS from Google Cloud Website and load it into BigQuery

# Step one

At first we will use short python script to get contents of the Google Cloud SKUs. In my case I will use https://cloud.google.com/skus/sku-groups/enterprise-agreement-2021-1 as the source data. If you will access this link you will see a thousands of SKUs.

In step one we will use Python script which will parse the URL and save it to CSV file.

```Python
import requests
from bs4 import BeautifulSoup
import csv

# URL of the Enterprise Agreement 2021.1 page
url = "https://cloud.google.com/skus/sku-groups/enterprise-agreement-2021-1"

# Send a GET request to fetch the HTML content of the page
response = requests.get(url)
if response.status_code == 200:
    soup = BeautifulSoup(response.text, 'html.parser')

    # Find the section containing the SKUs (depends on page structure)
    sku_table = soup.find('table')  # Assuming SKUs are in a table
    if sku_table:
        rows = sku_table.find_all('tr')  # Extract table rows

        # Prepare to save data to a CSV file
        with open('enterprise_agreement_skus.csv', 'w', newline='') as csvfile:
            csvwriter = csv.writer(csvfile)
            
            for row in rows:
                cols = row.find_all('td')  # Extract columns
                if cols:
                    # Extract and clean up column text
                    sku_data = [col.text.strip() for col in cols]
                    csvwriter.writerow(sku_data)  # Write data to the CSV file
        print("Data saved to enterprise_agreement_skus.csv")
    else:
        print("SKU table not found on the page.")
else:
    print(f"Failed to fetch the page. Status code: {response.status_code}")
```

# Step two
In step two we will use bash script to upload the CSV file into Google Cloud Storage and then we will ingest it into BigQuery. As you see in the variables we need to have Google Cloud project, bucket, dataset and table already pre-created.

```bash
#!/bin/bash

# Variables
PROJECT_ID="your_project_id"
BUCKET_NAME="your_bucket_name"
DATASET_NAME="your_dataset_name"
TABLE_NAME="your_table_name"
CSV_FILE="enterprise_agreement_skus.csv"

# Upload CSV to Google Cloud Storage
echo "Uploading $CSV_FILE to Google Cloud Storage bucket $BUCKET_NAME..."
gsutil cp $CSV_FILE gs://$BUCKET_NAME/

# Load CSV into BigQuery
echo "Loading $CSV_FILE into BigQuery table $DATASET_NAME.$TABLE_NAME..."
bq load \
  --autodetect \
  --source_format=CSV \
  $PROJECT_ID:$DATASET_NAME.$TABLE_NAME \
  gs://$BUCKET_NAME/$CSV_FILE

# Confirm success
if [ $? -eq 0 ]; then
  echo "CSV successfully imported into BigQuery table $DATASET_NAME.$TABLE_NAME."
else
  echo "Failed to import CSV into BigQuery. Check the logs for details."
fi
```