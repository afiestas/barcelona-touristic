library(stringr)

getBedsPerHood <- function() {
  listing <- read.csv('raw/airbin-listings.csv', stringsAsFactors = F)

  #there are 24 rows without beds, lets infer 23 of them using bedrooms
  listing[is.na(listing$beds) ,]$beds <- listing[is.na(listing$beds) ,]$bedrooms

  #Remove single outlier without beds and without bedrooms, it is a caravan
  listing <- listing[!is.na(listing$bed_type) ,]

  hoods <- unique(listing$neighbourhood_cleansed)

  bedsPerHood <- function(x) {
    x < as.character(x)
    beds <- sum(listing[listing$neighbourhood_cleansed ==  x,]$beds)
    frame <- data.frame(x, beds)
    colnames(frame) <- c('name', 'beds')

    return(frame)
  }

  bedsPerHood <- ldply(hoods, bedsPerHood)

  bedsPerHood$name <- str_to_title(bedsPerHood$name)

  return(bedsPerHood)
}