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

#We are missing 7 neighborhoods wich do not have touristic houses
# and 2 whos name include not populated areas such insdustrial parks
hoods[hoods$name == 'el Poble Sec - AEI Parc Montjuïc (1)', ]$name <- 'el Poble Sec'
hoods[hoods$name == 'la Marina del Prat Vermell - AEI Zona Franca (2)', ]$name <- 'la Marina del Prat Vermell'

#Removed not populated area in two neighborhoods according to source
#http://www.bcn.cat/estadistica/catala/dades/name/terri/sup/sup415.htm (AEI)
hoods[hoods$name == 'el Poble Sec', ]$area <- hoods[hoods$name == 'el Poble Sec', ]$area - 366.1
hoods[hoods$name == 'la Marina del Prat Vermell', ]$area <- hoods[hoods$name == 'la Marina del Prat Vermell', ]$area - 1353.1