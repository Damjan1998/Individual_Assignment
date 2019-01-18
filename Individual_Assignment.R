library('tidyverse') #loads data
library(mapdata)
install.packages('mapproj')
library('mapproj')

#import raw data
yug90_raw <- read.csv('D:/UCU/Labs/Intro to Data/Individual_Assignment/yug90.csv')   
rus90_raw <- read.csv('D:/UCU/Labs/Intro to Data/Individual_Assignment/rus90.csv')
yugruspop90_raw <- read.csv('D:/UCU/Labs/Intro to Data/Individual_Assignment/yugruspopulation90.csv')

#best death estimate per year in yugoslavia, data for 90 & 93-95 missing
yug_year <- yug90_raw %>%    
  group_by(year) %>%
  summarize(sumbest = sum(best)) %>%
  mutate(
    Country = 'Yugoslavia'
  )

#best death estimate per year in russia
rus_year <- rus90_raw %>% 
  group_by(year) %>%
  summarize(sumbest = sum(best)) %>%
  mutate(
    Country = 'Russia'
  )

#bind data for both countries
yugrus_year <- bind_rows(rus_year, yug_year) 
yugrus_year %>%
  mutate(
    year = as.character(year)
  )

#Makes the bars stacked next to each other from both data
ggplot() +    
  geom_col(data = yugrus_year, mapping = aes(x = year, y = sumbest, fill = Country), position='dodge') +
  ggtitle("Best total estimate of deaths per year") +
  xlab("Year") + ylab("Total recorded deaths")

#total deaths in 90s in yugoslavia
yug_total <- yug_year %>%   
  summarize(sumall = sum(sumbest))

#total deaths in 90s in russia
rus_total <- rus_year %>%   
  summarize(sumall= sum(sumbest))

# create dataframe with both these numbers
countries <- c('Russia', 'Yugoslavia') 
deathstotal <- c(rus_total$sumall, yug_total$sumall)
deaths_total <- data.frame(countries, deathstotal)

#total number of recorded deaths in the 90s per country
ggplot(data = deaths_total) +    
  geom_col(mapping = aes(x = countries, y = deathstotal)) + 
  ggtitle("Total deaths in the 90s by country") + 
  xlab("") + ylab("Total best estimate of deaths")

#calculates the average population for both countries in the 90s
population_average <- yugruspop90_raw %>%   
  summarize(average_yugoslav = mean(yug_population), average_russian = mean(rus_population))

#can I make this into a vector and join it to another dataframe? 
#- changed a bit; first is russia, second yugoslav population, entered manually
popavg <- c(148318100, 23338500) 
avgpop_country <- data.frame(countries, popavg)  #made this dataframe so I could use left_join

new_deaths_total <- left_join(deaths_total, avgpop_country)

#total number of recorded deaths per average population in the 90s per country
#technically shows how many people died due to recorded violence in promilles
ggplot(data = new_deaths_total) +    
  geom_col(mapping = aes(x = countries, y = 1000*deathstotal/popavg)) + 
  ggtitle("Relative total deaths per average population in the 90s") +
  xlab("") + ylab("Deaths in promilles(‰) of average population")

#mutate populations to make nice figures
population_yugrus_forfacet <- yugruspop90_raw %>%
  gather(
    'yug_population', 'rus_population',
    key = 'Country',
    value = 'Population'
  )

#population changes during the 90s
ggplot(data = population_yugrus_forfacet) +
  geom_line(mapping = aes(x = year, y = Population/1000000, group=Country)) +
  facet_wrap(~Country, nrow = 2, scales='free_y') +
  ggtitle("Population changes during the 90s") + 
  xlab("Year") + ylab("Population in millions")

#map the types of violence on a world map to compare
ggplot() + #plots a map of eurasia with where violence occured
  geom_polygon(data = map_data('world'), mapping = aes(x = long, y = lat, group = group), alpha = 0.6) +
  coord_fixed(xlim = c(0, 80), ylim = c(35, 70), ratio = 1.5) +
  geom_point(data = rus90_raw, mapping = aes(x = longitude, y = latitude, colour = type_of_violence)) +
  geom_point(data = yug90_raw, mapping = aes(x = longitude, y = latitude, colour = type_of_violence))

#let's look at yugoslavia specifically, coords to map: 12-24,  40-47
ggplot() + #plots a map of eurasia with where violence occured
  geom_polygon(data = map_data('world'), mapping = aes(x = long, y = lat, group = group), alpha = 0.6) +
  coord_fixed(xlim = c(12, 24), ylim = c(40, 47), ratio = 1) +
  geom_point(data = yug90_raw, mapping = aes(x = longitude, y = latitude, colour = type_of_violence))



joined_yugrus <- right_join(yug_total, rus_total)

map_data_table <- map_data('world')
 