library('tidyverse') #loads data
library(mapdata)
install.packages('mapproj')
library('mapproj')

yug90_raw <- read.csv('D:/UCU/Labs/Intro to Data/Individual_Assignment/yug90.csv')   #import raw data
rus90_raw <- read.csv('D:/UCU/Labs/Intro to Data/Individual_Assignment/rus90.csv')
yugruspop90_raw <- read.csv('D:/UCU/Labs/Intro to Data/Individual_Assignment/yugruspopulation90.csv')

yug_year <- yug90_raw %>%    #best death estimate per year in yugoslavia, data for 90 & 93-95 missing
  group_by(year) %>%
  summarize(sumbest = sum(best)) %>%
  mutate(
    Country = 'Yugoslavia'
  )

rus_year <- rus90_raw %>% #best death estimate per year in russia
  group_by(year) %>%
  summarize(sumbest = sum(best)) %>%
  mutate(
    Country = 'Russia'
  )

yugrus_year <- bind_rows(rus_year, yug_year)
yugrus_year %>%
  mutate(
    year = as.character(year)
  )

ggplot() +    #I wanna make the bars stacked next to each other from both data
  geom_col(data = yugrus_year, mapping = aes(x = year, y = sumbest, fill = Country), position='dodge')
  

yug_total <- yug_year %>%
  summarize(sumall = sum(sumbest))

rus_total <- rus_year %>% 
  summarize(sumall= sum(sumbest))

countries <- c('Russia', 'Yugoslavia')
deathstotal <- c(rus_total$sumall, yug_total$sumall)
deaths_total <- data.frame(countries, deathstotal)

ggplot(data = deaths_total) +    #total number of recorded deaths in the 90s per country
  geom_col(mapping = aes(x = countries, y = deathstotal))

population_average <- yugruspop90_raw %>%   #calculates the average population for both countries in the 90s
  summarize(average_yugoslav = mean(yug_population), average_russian = mean(rus_population))

popavg <- c(148318100, 23338500) #can I make this into a vector and join it to another dataframe? - changed a bit; first is russia, second yugoslav population, entered manually
avgpop_country <- data.frame(countries, popavg)  #made this dataframe so I could use left_join

new_deaths_total <- left_join(deaths_total, avgpop_country)

ggplot(data = new_deaths_total) +    #total number of recorded deaths per average population in the 90s per country
  geom_col(mapping = aes(x = countries, y = 1000*deathstotal/popavg)) #technically shows how many people died due to recorded violence in promilles


#map the types of violence on a world map to compare



ggplot() + #plots a map of eurasia with where violence occured
  geom_polygon(data = map_data('world'), mapping = aes(x = long, y = lat, group = group), alpha = 0.6) +
  coord_fixed(xlim = c(0, 80), ylim = c(35, 70), ratio = 1) +
  geom_point(data = rus90_raw, mapping = aes(x = longitude, y = latitude, colour = type_of_violence)) +
  geom_point(data = yug90_raw, mapping = aes(x = longitude, y = latitude, colour = type_of_violence))

#let's look at yugoslavia specifically, coords to map: 12-24,  40-47

ggplot() + #plots a map of eurasia with where violence occured
  geom_polygon(data = map_data('world'), mapping = aes(x = long, y = lat, group = group), alpha = 0.6) +
  coord_fixed(xlim = c(12, 24), ylim = c(40, 47), ratio = 1) +
  geom_point(data = yug90_raw, mapping = aes(x = longitude, y = latitude, colour = type_of_violence))

joined_yugrus <- right_join(yug_total, rus_total)

map_data_table <- map_data('world')
 