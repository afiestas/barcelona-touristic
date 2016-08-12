library('ggplot2') # visualization
library('ggthemes') # visualization
library('plyr') # ldply
library('dplyr') #Filter
library('rjson')
library('Hmisc') #For nin operator
library(stringr)

source('hotels.R')
source('touristic_houses.R')
source('neighborhoods_pop_area.R')


#plot only the busiest neighborhoods
ggplot(neighborhoods, aes(reorder(name, -touristic.houses), y = touristic.houses)) +
  geom_bar(stat = 'identity') + theme_few() +
  theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
  labs(y = 'Touristic Houses', x = 'Neighborhoods')

#Filter out neightborhoods without many touristic houses
threshold = 5
mostHouses = max(neighborhoods$touristic.houses)
busiestHoods = filter(neighborhoods, touristic.houses * 100 / mostHouses > threshold)

#plot only the busiest neighborhoods
ggplot(busiestHoods, aes(reorder(name, -touristic.houses), y = touristic.houses)) +
  geom_bar(stat = 'identity') + theme_few() +
  theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
  labs(y = 'Touristic Houses', x = 'Neighborhoods')



#Lets check if we are missing any neighborhoods in our neighborhood df
hoods[hoods$name %nin% neighborhoods$name , ]

neighborhoods <- merge(neighborhoods, hoods[, -1])

neighborhoods$name <- str_to_title(neighborhoods$name)

#We are done with this df
rm(hoods)