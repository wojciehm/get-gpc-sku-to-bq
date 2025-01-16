# How to get list of all SKU-IDS from Google Cloud Website and load it into BigQuery

# Step one

At first we will use short python script to get contents of the Google Cloud SKUs. In my case I will use https://cloud.google.com/skus/sku-groups/enterprise-agreement-2021-1 as the source data. If you will access this link you will see a thousands of SKUs.

Before running the script we need to install python requirements first. We can do it with `pip install -r requirements.txt`.

In step one we will use Python script which will parse the URL and save it to CSV file.

Run it as follows `python3 scrape.py`.

## Scrape Script
For details on how the scraping is implemented, refer to the following file:

https://github.com/wojciehm/get-gpc-sku-to-bq/blob/3da4b45b73ff219fc50f8496e7169a4cb40f7066/scrape.py#L1-32

# Step two
In step two we will use bash script to upload the CSV file into Google Cloud Storage and then we will ingest it into BigQuery. As you see in the variables we need to have Google Cloud project, bucket, dataset and table already pre-created.

https://github.com/wojciehm/get-gpc-sku-to-bq/blob/3da4b45b73ff219fc50f8496e7169a4cb40f7066/upload-to-bq.sh

Of course you need to make shell script executable, it can be done by typing in command `chmod +x upload-to-bq.sh`.

Then run script in your command line environment by running `./upload-to-bq.sh`.

![Script executed in Google Cloud Shell](cloud_shell_execution.png)

After that we can see that data is uploaded to BigQuery and can be analyzed :)

![Data is uploaded to BigQuery](data_uploaded_to_bq.png)

Voila! :)
