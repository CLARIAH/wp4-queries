library(httr) # needed for the GET command
library(jsonlite) # needed for fromJSON
key = "token"
data <- GET(("https://api.druid.datalegend.net/queries/dataLegend/microheights-to-table/15/run?page=1&pageSize=10000"),  add_headers(Authorization = paste("bearer", key)))
data <- fromJSON(content(data, as = 'text', encoding = "UTF-8"))
page = 1 # counts how many pages you queried so far
cont = nrow(data) == 10000 # tells the loop whether to start
while(cont && page < 500){ # prevents an endless loop; adjust the maximum number of pages based on your dataset's size.
  page = page+1
  n1 = nrow(data) # how many rows existed before
  fetch <- GET(sprintf("https://api.druid.datalegend.net/queries/dataLegend/microheights-to-table/15/run?page=%i&pageSize=10000", page),  add_headers(Authorization = paste("bearer", key))) # queries the next page
  fetch <- fromJSON(content(fetch, as = 'text', encoding = "UTF-8"))
  data = rbind(data, fetch)
  n2 = nrow(data) # how many rows exist after
  cont = (n2 - n1) == 10000 # checks whether the next query will pick any more rows; if not, the loop stops
  #print(page) # if you want to follow what's going on
}
