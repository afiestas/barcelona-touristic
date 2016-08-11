#!/usr/bin/env Rscript
library(httr)
library(XML)
library(jsonlite)

f <- file("stdin")
open(f)
all = data.frame()
while(length(line <- readLines(f,n=1)) > 0) {
  streetInfo = strsplit(line, ':')
  streetName = streetInfo[[1]][1]
  streetNum = streetInfo[[1]][2]
  # # write(paste(streetName, streetNum), stderr())
  # 
  # r = POST('http://w20.bcn.cat/GuiaWS/GuiaWS.asmx/LocalizaVia', body = list(Via = streetName), encode = 'form')
  # xml = content(r, as='text')
  # root = xmlRoot(xmlParse(xml))
  # if (is.null(root[['rDatosVia']][['NumTrobat']])) {
  #   write(paste("Couldn't find street", streetName), stderr())
  #   next()
  # }
  # 
  # num = xmlApply(root[['rDatosVia']][['NumTrobat']], xmlValue)
  # # write(paste("Found number:", num), stderr())
  # 
  # if (length(num) == 0) {
  #   write(paste("Couldn't fetch number", streetName), stderr())
  #   next()
  #   write(paste("11111111111111111111111111", streetName), stderr())
  # }

  r = POST('http://w20.bcn.cat/GuiaWS/GuiaWS.asmx/DireccionPostal', body = list(Calle = streetName, Numero = streetNum), encode = 'form')
  if ( r$status_code != 200 ) {
    write("A request failed", stdout())
    quit(save = 'no', status = 1)
  }
  xml = content(r, as='text')
  root = xmlRoot(xmlParse(xml))
  if (is.null(root[['Direcciones']][['Direccion']])) {
    write(paste0("WTF: ", streetName," ",streetNum), stderr())
    next()
  }

  names = xmlApply(root[['Direcciones']][['Direccion']], xmlName)
  values = xmlApply(root[['Direcciones']][['Direccion']], xmlValue)
  
  extraInfo = data.frame(values)
  colnames(extraInfo) < names
  
  all = rbind(all, extraInfo)
  # process line
}

toJSON(all)