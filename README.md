# Barcelona toursit density

#### Legal (registered) touristic houses
The barcelona city council requires tourist houses to be registered in a census which is publicly available at: [bcn opendata](http://opendata.bcn.cat/opendata/ca/catalog/TURISME/habitatgesusturistic/)

The file can be found within the project at **raw/hut_comunicacio.csv**
We extract form this file the amount of touristic houses per neighborhood
and save it in **curated/touristic_houses.csv**

### Hotels in Barcelona
We can get a list of all the hotels in Barcelona by downloading a list of all hotels in Catalonia which is available at: [gencat](http://dadesobertes.gencat.cat/en/cercador/detall-cataleg/?id=230)

After downloading the file, we use **extractBarcelona.py** to get hotels only from barcelona generating the file **curated/barcelona-hotels.xml**

Once we have an xml containing only hotels from Barcelona we conver it to json since it is more convinient to parse in R, using [xmlToJSON](https://github.com/metatribal/xmlToJSON) which generated the file **curated/barcelona-hotels.json**

In **hotels.R** we filer all the hotels which are open and create a new list of
hotels with their addresses and available number of beds.

From the addresses we use a Barcelona city council provided API to lookup the neighborhood that address (street name, num) belonigs to. We have the result in **curated/barcelona-hotels.csv**

### Airbnb beds available in Barcelona
We can get all the listings in the city of Barcelona in the insideairbnb project
[insideairbnb](http://data.insideairbnb.com/spain/catalonia/barcelona/2016-01-03/visualisations/listings.csv) which can be found at **raw/airbnb_listings.csv**. 

From this raw data we extract the amount of beds per neighborhood and save the result in **curated/airbnb.csv**
