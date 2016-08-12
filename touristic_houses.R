#Reads the touristic houses from

library(stringr)

getTouristicHouses <- function() {
  #Read original data as Latin1, encode it to UTF-8
  data = read.csv2('hut_comunicacio.csv', stringsAsFactors = F, encoding = 'UTF-8', fileEncoding = 'ISO8859-1')

  #EXPEDIENT seems to be date + a number, get the date
  data$DATE_STR <- sapply(data$EXPEDIENT, function(x) paste('01-', substr(x, 1, nchar(x) -5), sep = ''))
  data$DATE <- as.Date(data$DATE_STR)

  data$EXPEDIENT_NUM <- sapply(data$EXPEDIENT, function(x) strsplit(x, '-')[[1]][3])

  #Create a df for neighborhoods, atm with just the amount of touristic hosues
  neighborhoods = as.data.frame(table(data$BARRI), stringsAsFactors = F)
  colnames(neighborhoods) <- c('name', 'touristic.houses')

  neighborhoods$name <- str_to_title(neighborhoods$name)

  return(neighborhoods)
}