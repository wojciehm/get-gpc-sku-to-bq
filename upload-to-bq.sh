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

#!/bin/bash

# Variables
PROJECT_ID="your_project_id"
BUCKET_NAME="your_bucket_name"
DATASET_NAME="your_dataset_name"
TABLE_NAME="your_table_name"
CSV_FILE="enterprise_agreement_skus_$(date +%Y-%m-%d_%H-%M-%S).csv"  # Updated filename with date and time

# Scrape data (assuming you have a scraping script or data source to generate this)
# Example: scrape data and save it to a temporary file
SCRAPED_DATA="path/to/scraped_data.csv"  # Replace with the path to your actual scraped CSV

# Move the scraped data to the intended CSV file
mv $SCRAPED_DATA $CSV_FILE

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