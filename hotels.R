#This file parses barcelona-hotels.json which is an xml2json (npm) from
#http://dadesobertes.gencat.cat/en/cercador/detall-cataleg/?id=230
#and filtered so we only get Barcelona hotels instead of all Catalonia

library(dplyr)
library(stringr)
library(jsonlite)

getBarcelonaHotels <- function() {
  hotels <- fromJSON(txt='barcelona-hotels.json', flatten = T)
  
  hotels <- hotels$extraccio$objRegistral
  
  #Only the hotels that are actually on service
  hotels <- hotels[hotels$dades_generals.estat == 'ALTA', ]

  #Select the total available places
  hotels$places <- lapply(hotels$places.placa, function(x) x[x$id == '20' ,]$num_places)
  #Filtering all columns we do not want
  hotels <- select(hotels, dades_generals.retol, dades_generals.adreca.nom_via, dades_generals.adreca.num, places)
  #Put some names that make sense
  colnames(hotels) <- c('name', 'street', 'num', 'places' )

  hotels$street <- str_trim(hotels$street)
  
  #These 4 hotels have the street number in the street name
  hotels[hotels$street == 'Aragó, 569 bis-579' ,]$num <- '579'
  hotels[hotels$street == 'Aragó, 569 bis-579' ,]$street <- 'Aragó'
  
  hotels[hotels$street == 'Aragó, 323-325' ,]$num <- '323-325'
  hotels[hotels$street == 'Aragó, 323-325' ,]$street <- 'Aragó'
  
  hotels[hotels$street == 'Pujades, 120-122' ,]$num <- '120-122'
  hotels[hotels$street == 'Pujades, 120-122' ,]$street <- 'Pujades'
  
  hotels[hotels$street == 'Mallorca, 216' ,]$num <- '216'
  hotels[hotels$street == 'Mallorca, 216' ,]$street <- 'Mallorca'

  hotels[hotels$street == "Països Catalans" ,]$num <- "1"
  hotels[hotels$street == "Països Catalans" ,]$street <- "Pl dels Països Catalans"

  hotels[hotels$street == "Amílcar" ,]$num <- '118'
  hotels[hotels$street == "Pius XII" ,]$num <- '1'
  hotels[hotels$street == "Doctor Trueta" ,]$num <- '160'
  hotels[hotels$street == "Moll de Barcelona" ,]$num <- '1'

  hotels[hotels$street == "Marques d'Argentera" ,]$street <- "Marquès de l'Argentera"
  hotels[hotels$street == "Vallvidrera-Tibidabo" ,]$street <- "ctra vallvidrera tibidabo"
  hotels[hotels$street == "Junta del Comerç" ,]$street <- "Junta de Comerç"
  hotels[hotels$street == "de l'Àngel" ,]$street <- "Pl. de l'Àngel"
  hotels[hotels$street == "Dalt" ,]$street <- "Trav. de Dalt"
  hotels[hotels$street == "Garcia Faria" ,]$street <- "Pg. Garcia Faria"
  hotels[hotels$street == "Reial" ,]$street <- "Pl Reial"
  hotels[hotels$street == "Eduard Maristany" ,]$street <- "Av Eduard Maristany"
  hotels[hotels$street == "Rosa dels Vents" ,]$street <- "Pl Rosa dels Vents"
  hotels[hotels$street == "Sancho d'Àvila" ,]$street <- "Sancho de ávila"
  hotels[hotels$street == "Torrent de l' Olla" ,]$street <- "Torrent de l'Olla"
  hotels[hotels$street == "Litoral" ,]$street <- "Avda Litoral"

  hotels[hotels$street == "Taulat" & hotels$num == '30' ,]$street <- "Carrer del Taulat"
  hotels[hotels$street == "Taulat", ]$street <- "Pg. del Taulat"

  hotels <- hotels[hotels$street != "Franca-carrer K" ,]

  return(hotels)
}
