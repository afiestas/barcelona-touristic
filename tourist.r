library('ggplot2') # visualization
library('ggthemes') # visualization

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
  labs(y = 'Touristic Houses')
#Filter out neightborhoods without many touristic houses
threshold = 5
mostHouses = max(neighborhoods$TOURISTIC_HOUSES)
busiestHoods = filter(neighborhoods, TOURISTIC_HOUSES * 100 / mostHouses > threshold)

ggplot(busiestHoods, aes(x = NAME, y = TOURISTIC_HOUSES)) +
  geom_bar(stat = 'identity') + theme_few() +
  theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
  labs(y = 'Touristic Houses')
