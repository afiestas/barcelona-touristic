#!/usr/bin/env Rscript
library(httr)
library(XML)
library(jsonlite)


getStreetNumber <- function(street.name) {
  r = POST('http://w20.bcn.cat/GuiaWS/GuiaWS.asmx/LocalizaVia', body = list(Via = street.name), encode = 'form')
  xml = content(r, as='text')
  root = xmlRoot(xmlParse(xml))
  if (is.null(root[['rDatosVia']][['NumTrobat']])) {
    write(paste("Couldn't find street", street.name), stderr())
    return("-1")
  }

  num = xmlApply(root[['rDatosVia']][['NumTrobat']], xmlValue)
  # write(paste("Found number:", num), stderr())

  if (length(num) == 0) {
    write(paste("Couldn't fetch number", street.name), stderr())
    return("-2")
  }

  return(num)
}

getStreetInfo <- function(street.name, street.num) {
  write(paste0("Fetching ", street.name," ",street.num), stderr())
  r = POST('http://w20.bcn.cat/GuiaWS/GuiaWS.asmx/DireccionPostal', body = list(Calle = street.name, Numero = street.num), encode = 'form')
  if ( r$status_code != 200 ) {
    write("A request failed", stdout())
    return(NULL)
  }

  xml = content(r, as='text')
  root = xmlRoot(xmlParse(xml))
  if (is.null(root[['Direcciones']][['Direccion']])) {
    write(paste0("WTF: ", street.name," ",street.num), stderr())
    return(NULL)
  }

  names = xmlApply(root[['Direcciones']][['Direccion']], xmlName)
  values = xmlApply(root[['Direcciones']][['Direccion']], xmlValue)

  extraInfo = data.frame(values)
  colnames(extraInfo) < names

  return(extraInfo)
}