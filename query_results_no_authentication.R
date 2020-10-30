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
