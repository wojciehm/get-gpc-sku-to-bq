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

