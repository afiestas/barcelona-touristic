library('ggplot2') # visualization
library('ggthemes') # visualization
library('plyr') # ldply
library('dplyr') #Filter
library('rjson')
library('Hmisc') #For nin operator
library(stringr)

#Read original data as Latin1, encode it to UTF-8
data = read.csv2('hut_comunicacio.csv', stringsAsFactors = F, encoding = 'UTF-8', fileEncoding = 'ISO8859-1')

#EXPEDIENT seems to be date + a number, get the date
data$DATE_STR <- sapply(data$EXPEDIENT, function(x) paste('01-', substr(x, 1, nchar(x) -5), sep = ''))
data$DATE <- as.Date(data$DATE_STR)

data$EXPEDIENT_NUM <- sapply(data$EXPEDIENT, function(x) strsplit(x, '-')[[1]][3])

#Create a df for neighborhoods, atm with just the amount of touristic hosues
neighborhoods = as.data.frame(table(data$BARRI))
colnames(neighborhoods) <- c('name', 'touristic.houses')

#plot only the busiest neighborhoods
ggplot(neighborhoods, aes(reorder(NAME, -touristic.houses), y = touristic.houses)) +
  geom_bar(stat = 'identity') + theme_few() +
  theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
  labs(y = 'Touristic Houses', x = 'Neighborhoods')

#Filter out neightborhoods without many touristic houses
threshold = 5
mostHouses = max(neighborhoods$touristic.houses)
busiestHoods = filter(neighborhoods, touristic.houses * 100 / mostHouses > threshold)

#plot only the busiest neighborhoods
ggplot(busiestHoods, aes(reorder(NAME, -touristic.houses), y = touristic.houses)) +
  geom_bar(stat = 'identity') + theme_few() +
  theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
  labs(y = 'Touristic Houses', x = 'Neighborhoods')

dades <- fromJSON(file='barcelona-hotels.json')
dades <- dades$extraccio$objRegistral

dades <- Filter(function(x) x$dades_generals$estat == 'ALTA', dades)

extractHotel <- function (x) {
  cp = x$dades_generals$adreca$cp
  retols = x$dades_generals$retol
  street = str_trim(x$dades_generals$adreca$nom_via)
  num = x$dades_generals$adreca$num
  if (length(num) == 0) {
    num = NA
  }

  places = Filter(function(y) y$id == "20", x$places$placa)[[1]]$num_places
  if (is.null(places))
      places = NA
  data.frame(name = retols, cp = cp, places = places, street = street, num = num, stringsAsFactors = F)
}

hotels = ldply(dades, extractHotel)

#These 4 hotels have the street number in the street name
hotels[hotels$street == 'Aragó, 569 bis-579' ,]$num <- '579'
hotels[hotels$street == 'Aragó, 569 bis-579' ,]$street <- 'Aragó'

hotels[hotels$street == 'Aragó, 323-325' ,]$num <- '323-325'
hotels[hotels$street == 'Aragó, 323-325' ,]$street <- 'Aragó'

hotels[hotels$street == 'Pujades, 120-122' ,]$num <- '120-122'
hotels[hotels$street == 'Pujades, 120-122' ,]$street <- 'Pujades'

hotels[hotels$street == 'Mallorca, 216' ,]$num <- '216'
hotels[hotels$street == 'Mallorca, 216' ,]$street <- 'Mallorca'

#We are done with this df
rm(dades)

hoods = read.csv2('superficiedens2013.csv', stringsAsFactors = F, encoding = 'UTF-8', fileEncoding = 'ISO8859-1')

#Translate collumn names from Catalan to English
colnames(hoods) <- c('Dte', 'name', 'population', 'area', 'density', 'net.density')

#remove rows without names
hoods <- hoods[hoods$name != "", ]

#CSV has dot in the thousands
hoods$population <- as.numeric(gsub('\\.', '', hoods$population))
hoods$area <- as.numeric(gsub('\\.', '', hoods$area))
hoods$density <- as.numeric(gsub('\\.', '', hoods$density))
hoods$net.density <- as.numeric(gsub('\\.', '', hoods$net.density))

#Remove enumerator in the name 23. name --> name
hoods$name <-  gsub('\\d+\\. ', '', hoods$name, perl=T)

#Lets check if we are missing any neighborhoods in our neighborhood df
hoods[hoods$name %nin% neighborhoods$name , ]

#We are missing 7 neighborhoods wich do not have touristic houses
# and 2 whos name include not populated areas such insdustrial parks
hoods[hoods$name == 'el Poble Sec - AEI Parc Montjuïc (1)', ]$name <- 'el Poble Sec'
hoods[hoods$name == 'la Marina del Prat Vermell - AEI Zona Franca (2)', ]$name <- 'la Marina del Prat Vermell'

#Removed not populated area in two neighborhoods according to source
#http://www.bcn.cat/estadistica/catala/dades/name/terri/sup/sup415.htm (AEI)
hoods[hoods$name == 'el Poble Sec', ]$area <- hoods[hoods$name == 'el Poble Sec', ]$area - 366.1
hoods[hoods$name == 'la Marina del Prat Vermell', ]$area <- hoods[hoods$name == 'la Marina del Prat Vermell', ]$area - 1353.1

neighborhoods <- merge(neighborhoods, hoods[, -1])

#We are done with this df
rm(hoods)