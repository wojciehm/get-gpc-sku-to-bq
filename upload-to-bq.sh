#!/bin/bash

# Variables
PROJECT_ID="wojciech-backup"
BUCKET_NAME="wojciech-bq-import"
DATASET_NAME="wojciechskubqdataset"
TABLE_NAME="wojciechskubqtable"
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