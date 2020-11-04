data <- read.csv(url("https://api.druid.datalegend.net/queries/LaurensRietveld/pagination/run.csv?page=1&pageSize=10000"))
page = 1 # counts how many pages you queried so far
cont = TRUE # tells the loop to continue
while(cont && page < 100){ # prevents an endless loop; adjust the maximum number of pages based on your dataset's size.
  page = page+1
  n1 = nrow(data) # how many rows existed before
  data <- rbind(data, read.csv(url(sprintf("https://api.druid.datalegend.net/queries/LaurensRietveld/pagination/run.csv?page=%i&pageSize=10000", page)))) # queries the next page
  n2 = nrow(data) # how many rows exist after
  cont = (n2 - n1) == 10000 # checks whether the next query will pick any more rows; if not, the loop stops
  #print(page) # if you want to follow what's going on
}

### it is possible that in some instances not all results are read correctly by R. Perhaps due to read.csv or the specification .csv in the api? 
### can be solved by using fromJSON and removing the .csv specification from the url:

ibrary(jsonlite)
library(rjson)

data <- jsonlite::fromJSON("https://api.druid.datalegend.net/queries/dataLegend/microheights-to-table/15/run?page=1&pageSize=10000")
page = 1 # counts how many pages you queried so far
cont = TRUE # tells the loop to continue
while(cont && page < 1000){ # prevents an endless loop; adjust the maximum number of pages based on your dataset's size.
  page = page+1
  n1 = nrow(data) # how many rows existed before
  data <- rbind(data, jsonlite::fromJSON(sprintf("https://api.druid.datalegend.net/queries/dataLegend/microheights-to-table/15/run?page=%i&pageSize=10000", page))) # queries the next page
  n2 = nrow(data) # how many rows exist after
  cont = (n2 - n1) == 10000 # checks whether the next query will pick any more rows; if not, the loop stops
  print(page) # if you want to follow what's going on
}
