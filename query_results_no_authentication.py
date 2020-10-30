import requests, json
import pandas as pd

# make empty list to store results

total_results = []

# make list of page numbers (adapt range to expected n of results)

for page_num in range(1, 40):
    url = "https://api.druid.datalegend.net/queries/RubenS/all-obs/3/run?pageSize=10000&page=" + str(page_num)
    print(url)

# Loop through from pages (adapt range to expected n of results)

for page_num in range(1, 40):
    # Build the URL and download the results
    url = "https://api.druid.datalegend.net/queries/RubenS/all-obs/3/run?pageSize=10000&page=" + str(page_num)
    print("Downloading", url)
    response = requests.get(url)
    data = response.json()
    total_results = total_results + data

# write total_results to csv

df = pd.DataFrame(total_results)
#data.read_json(data)
df.to_csv('results.csv')
