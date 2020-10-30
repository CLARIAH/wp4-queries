library(httr) # needed for the GET command
# Source: https://nightly.triplydb.com/BennyMarkovitch/-/queries/Query
key = "token" # insert token here
data <- content(GET(("https://api.nightly.triplydb.com/queries/BennyMarkovitch/Query/run.csv?page=1&pageSize=10000"),  add_headers(Authorization = paste("bearer", key)))) # this link stores the query's output
page = 1 # counts how many pages you queried so far
cont = nrow(data) == 10000 # tells the loop whether to start
while(cont && page < 100){ # prevents an endless loop; adjust the maximum number of pages based on your dataset's size.
  page = page+1
  n1 = nrow(data) # how many rows existed before
  data <- rbind(data, content(GET(sprintf("https://api.nightly.triplydb.com/queries/BennyMarkovitch/Query/run.csv?page=%i&pageSize=10000", page),  add_headers(Authorization = paste("bearer", key))))) # queries the next page
  n2 = nrow(data) # how many rows exist after
  cont = (n2 - n1) == 10000 # checks whether the next query will pick any more rows; if not, the loop stops
  #print(page) # if you want to follow what's going on
}
