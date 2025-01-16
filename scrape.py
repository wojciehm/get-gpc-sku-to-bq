import requests
from bs4 import BeautifulSoup
import csv

# URL of the Enterprise Agreement page (to be passed as an argument or set as a default)
URL = "https://cloud.google.com/skus/sku-groups/enterprise-agreement-2021-1"  # Default URL

# Function to scrape the data from the provided URL
def scrape_sku_data(url=URL):
    # Send a GET request to fetch the HTML content of the page
    response = requests.get(url)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')

        # Find the section containing the SKUs (depends on page structure)
        sku_table = soup.find('table')  # Assuming SKUs are in a table
        if sku_table:
            rows = sku_table.find_all('tr')  # Extract table rows

            # Prepare to save data to a CSV file with date and time in filename
            from datetime import datetime
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            csv_filename = f'enterprise_agreement_skus_{timestamp}.csv'
            
            with open(csv_filename, 'w', newline='') as csvfile:
                csvwriter = csv.writer(csvfile)
                
                for row in rows:
                    cols = row.find_all('td')  # Extract columns
                    if cols:
                        # Extract and clean up column text
                        sku_data = [col.text.strip() for col in cols]
                        csvwriter.writerow(sku_data)  # Write data to the CSV file
            print(f"Data saved to {csv_filename}")
        else:
            print("SKU table not found on the page.")
    else:
        print(f"Failed to fetch the page. Status code: {response.status_code}")

# Call the function to scrape the data from the URL
scrape_sku_data()