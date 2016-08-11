#This file parses barcelona-hotels.json which is an xml2json (npm) from
#http://dadesobertes.gencat.cat/en/cercador/detall-cataleg/?id=230
#and filtered so we only get Barcelona hotels instead of all Catalonia

library(rjson)
library(dplyr)

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

getBarcelonaHotels <- function() {
  dades <- fromJSON(file='barcelona-hotels.json')
  dades <- dades$extraccio$objRegistral
  
  dades <- Filter(function(x) x$dades_generals$estat == 'ALTA', dades)
  
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

  hotels[hotels$street == "Països Catalans" ,]$num <- "1"
  hotels[hotels$street == "Països Catalans" ,]$street <- "Pl dels Països Catalans:1"

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
  hotels[hotels$street == "Taulat" ,]$street <- "Pg. del Taulat"
  hotels[hotels$street == "Reial" ,]$street <- "Pl Reial"
  hotels[hotels$street == "Eduard Maristany" ,]$street <- "Av Eduard Maristany"
  hotels[hotels$street == "Rosa dels Vents" ,]$street <- "Pl Rosa dels Vents"

  return(hotels)
}