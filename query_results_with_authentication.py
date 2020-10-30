import requests, json
import pandas as pd

# make empty list to store results

total_results = []

# pass authentication

access_token = 'YOUR API TOKEN OBTAINED FROM DRUID > USER SETTINGS > API TOKENS'

# make list of page numbers (adapt range to expected n of results)

for page_num in range(1, 40):
    url = "https://api.druid.datalegend.net/queries/RubenS/all-obs/3/run?pageSize=10000&page=" + str(page_num)
    print(url)

# Loop through from pages (adapt range to expected n of results)

for page_num in range(1, 40):
    # Build the URL and download the results
    url = "https://api.druid.datalegend.net/queries/RubenS/all-obs/3/run?pageSize=10000&page=" + str(page_num)
    print("Downloading", url)
    response = requests.get(url, headers={'Authorization': 'Bearer {}'.format(access_token)})
    data = response.json()
    total_results = total_results + data

# write total_results to csv

df = pd.DataFrame(total_results)
#data.read_json(data)
df.to_csv('results.csv')

## if you have an API key add this:
#access_token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ1bmtub3duIiwiaXNzIjoiaHR0cHM6Ly9hcGkuZHJ1aWQuZGF0YWxlZ2VuZC5uZXQiLCJqdGkiOiJhMzgxNzE3Ni0xZGNmLTQ1ZTMtYTZhYi04ODk3YjdmYjViYzUiLCJ1aWQiOiI1YTAxOTEwMmI4YmRiMzAyNDBhZDM1MzciLCJpYXQiOjE2MDM4NzczNTh9.DXiRo7iY8y9G7hQBKEqFl8t1WY-yNKapMMOo945hUoU'
#result = requests.post(url,
#      headers={'Authorization': 'Bearer {}'.format(access_token)})
