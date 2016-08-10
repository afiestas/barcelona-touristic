library('ggplot2') # visualization
library('ggthemes') # visualization
library('dplyr')
library('rjson')
library('plyr')

#Read original data as Latin1, encode it to UTF-8
data = read.csv2('hut_comunicacio.csv', stringsAsFactors = F, encoding = 'UTF-8', fileEncoding = 'ISO8859-1')

#EXPEDIENT seems to be date + a number, get the date
data$DATE_STR <- sapply(data$EXPEDIENT, function(x) paste('01-', substr(x, 1, nchar(x) -5), sep = ''))
data$DATE <- as.Date(data$DATE_STR)

data$EXPEDIENT_NUM <- sapply(data$EXPEDIENT, function(x) strsplit(x, '-')[[1]][3])
head(data)

#Create a df for neighborhoods, atm with just the amount of touristic hosues
neighborhoods = as.data.frame(table(data$BARRI))
colnames(neighborhoods) <- c('NAME', 'TOURISTIC_HOUSES')

#plot only the busiest neighborhoods
ggplot(neighborhoods, aes(reorder(NAME, -TOURISTIC_HOUSES), y = TOURISTIC_HOUSES)) +
  geom_bar(stat = 'identity') + theme_few() +
  theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
  labs(y = 'Touristic Houses', x = 'Neighborhoods')

#Filter out neightborhoods without many touristic houses
threshold = 5
mostHouses = max(neighborhoods$TOURISTIC_HOUSES)
busiestHoods = filter(neighborhoods, TOURISTIC_HOUSES * 100 / mostHouses > threshold)

#plot only the busiest neighborhoods
ggplot(busiestHoods, aes(reorder(NAME, -TOURISTIC_HOUSES), y = TOURISTIC_HOUSES)) +
  geom_bar(stat = 'identity') + theme_few() +
  theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
  labs(y = 'Touristic Houses', x = 'Neighborhoods')


dades <- fromJSON(file='barcelona-hotels.json')
dades <- dades$extraccio$objRegistral

dades <- Filter(function(x) x$dades_generals$estat == 'ALTA', dades)

extractHotel <- function (x) {
  cp = x$dades_generals$adreca$cp
  retols = x$dades_generals$retol
  places = Filter(function(y) y$id == "20", x$places$placa)[[1]]$num_places
  if (is.null(places))
      places = NA
  data.frame(name = retols, cp = cp, places = places)
}

l = ldply(dades, extractHotel)

hoods = read.csv2('superficiedens2013.csv', stringsAsFactors = F, encoding = 'UTF-8', fileEncoding = 'ISO8859-1')
hoods$Barris <-  gsub('\\d+\\. ', '', hoods$Barris, perl=T)
hoods <- hoods[hoods$Barris != "", ]
