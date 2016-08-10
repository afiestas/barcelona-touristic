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
  # message(paste(streetName, streetNum))

  r = POST('http://w20.bcn.cat/GuiaWS/GuiaWS.asmx/DireccionPostal', body = list(Calle = streetName, Numero = streetNum), encode = 'form')
  if ( r$status_code != 200 ) {
    write("A request failed", stdout())
    quit(save = 'no', status = 1)
  }
  xml = content(r, as='text')
  root = xmlRoot(xmlParse(xml))
  names = xmlApply(root[['Direcciones']][['Direccion']], xmlName)
  values = xmlApply(root[['Direcciones']][['Direccion']], xmlValue)
  
  extraInfo = data.frame(values)
  colnames(extraInfo) < names
  
  all = rbind(all, extraInfo)
  # process line
}

toJSON(all)